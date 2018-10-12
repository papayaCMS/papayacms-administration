<?php
/**
 * papaya CMS
 *
 * @copyright 2000-2018 by papayaCMS project - All rights reserved.
 * @link http://www.papaya-cms.com/
 * @license http://www.gnu.org/licenses/old-licenses/gpl-2.0.html GNU General Public License, version 2
 *
 *  You can redistribute and/or modify this script under the terms of the GNU General Public
 *  License (GPL) version 2, provided that the copyright and license notes, including these
 *  lines, remain unmodified. papaya is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 *  FOR A PARTICULAR PURPOSE.
 */

/**
* Translate phrase
*
* @param string $phrase
* @param mixed $module optional, default value NULL
* @access public
* @return string
*/
function _gt($phrase, $module = NULL) {
  /** @var Papaya\Application\CMS $application */
  $application = \Papaya\Application::getInstance();
  if ($application->hasObject('Phrases') && '' !== trim($phrase)) {
    return $application->administrationPhrases->getText($phrase, $module);
  }
  return $phrase;
}

/**
* Load text out of file
*
* @param string $fileName
* @access public
* @return string
*/
function _gtfile($fileName) {
  if (isset($GLOBALS['PAPAYA_USER'])) {
    $fileName = __DIR__.'/data/'.
      $GLOBALS['PAPAYA_USER']->options['PAPAYA_UI_LANGUAGE'].'/'.$fileName;
  } else {
    $language = \Papaya\Application::getInstance()->options->get('PAPAYA_UI_LANGUAGE', 'en-US');
    $fileName = __DIR__.'/data/'.$language.'/'.$fileName;
  }
  if ($fileName) {
    if ($fh = @fopen($fileName, 'r')) {
      $data = fread($fh, filesize($fileName));
      fclose($fh);
      return $data;
    }
  }
  return '';
}

/**
 * Include file or redirect to
 *
 * @param string $includeFile
 * @return boolean|\Papaya\Application|\Papaya\Application\CMS
 * @access public
 */
function includeOrRedirect($includeFile) {
  if (defined('PAPAYA_DBG_DEVMODE') && PAPAYA_DBG_DEVMODE) {
    $result = include_once($includeFile);
  } else {
    $result = @include_once($includeFile);
  }
  if (!class_exists('PapayaAutoloader', FALSE)) {
    redirectToInstaller();
  }
  return $result;
}

/**
* Redirect to installer
*
* @access public
*/
function redirectToInstaller() {
  $protocol = (isset($_SERVER['HTTPS']) && 'on' === strtolower($_SERVER['HTTPS']))
    ? 'https' : 'http';
  $url = $protocol.'://'.$_SERVER['HTTP_HOST'].dirname($_SERVER['PHP_SELF']);
  $url = str_replace('\\', '/', $url);
  if ('/' !== substr($url, -1)) {
    $url .= '/';
  }
  $url .= 'install.php';
  redirectToURL($url);
  exit;
}

function redirectToURL($url) {
  if (PHP_SAPI === 'cgi' || PHP_SAPI === 'fast-cgi') {
    @header('Status: 302 Found');
  } else {
    @header('HTTP/1.1 302 Found');
  }
  header('Location: '.$url);
  exit;
}

/**
 * Initialize navigation
 *
 * @access public
 * @param null $fileName
 */
function initNavigation($fileName = NULL) {
  $GLOBALS['PAPAYA_NAVIGATION'] = new papaya_navigation();
  $GLOBALS['PAPAYA_NAVIGATION']->layout = $GLOBALS['PAPAYA_LAYOUT'];
  $GLOBALS['PAPAYA_NAVIGATION']->initialize($fileName);
}

function controlScriptFileCaching(
  $fileName, $isPrivate = TRUE, $allowGzip = TRUE, $directoriesUp = 4
) {
  $application = setUpApplication($directoriesUp);
  $themeCacheTime = $application->options->get('PAPAYA_CACHE_TIME_THEMES');
  $etag = md5($fileName);
  $modified = @filemtime($fileName);
  if (isset($_SERVER['HTTP_IF_NONE_MATCH'])) {
    if ($etag === $_SERVER['HTTP_IF_NONE_MATCH'] ||
        '"'.$etag.'"' === $_SERVER['HTTP_IF_NONE_MATCH']) {
      if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) &&
          $modified < (strtotime($_SERVER['HTTP_IF_MODIFIED_SINCE']) + $themeCacheTime)) {
        if (PHP_SAPI === 'cgi' || PHP_SAPI === 'fast-cgi') {
          @header('Status: 304 Not Modified');
        } else {
          @header('HTTP/1.1 304 Not Modified');
        }
        exit;
      }
    }
  }
  header('Last-Modified: '.gmdate('D, d M Y H:i:s', $modified).' GMT');
  header('Expires: '.gmdate('D, d M Y H:i:s', (time() + 2592000)).' GMT');
  if ($isPrivate) {
    header('Cache-Control: private, max-age=10800, pre-check=10800, no-transform');
  } else {
    header('Cache-Control: public, max-age=2592000, pre-check=2592000, no-transform');
  }
  header('Etag: "'.$etag.'"');
  header('X-Generator: papaya 5');
  if ($allowGzip) {
    ob_start('outputCompressionHandler');
  }
}

function outputCompressionHandler($buffer, $mode) {
  static $output = TRUE;
  if ($output &&
      !headers_sent() &&
      function_exists('ob_gzhandler') &&
      @ini_get('zlib.output_compression') != TRUE) {
    $output = FALSE;
    $compressed = ob_gzhandler(
      $buffer,
      $mode
    );
    return $compressed;
  } elseif ($output) {
    return $buffer;
  }
  return NULL;
}

function includeThemeDefinition() {
  $application = setUpApplication();
  $color = $application->options->get('PAPAYA_UI_THEME', 'green');
  $theme = $application->options->get('PAPAYA_UI_SKIN', 'default');
  $themeFile = __DIR__.'/skins/'.$theme.'/theme_'.$color.'.php';
  include_once($themeFile);
}

/**
 * @param int $directoriesUp
 * @return \Papaya\Application|\Papaya\Application\CMS
 */
function setUpApplication($directoriesUp = 4) {
  static $application;
  if (empty($application)) {
    setUpAutoloader($directoriesUp);
    /** @var \Papaya\Application\CMS $application */
    $application = \Papaya\Application::getInstance();
    $application->registerProfiles(
      new \Papaya\Application\Profiles\CMS(), \Papaya\Application::DUPLICATE_IGNORE
    );
    $application->response = new \Papaya\Response();
    $application->options->loadAndDefine();
  }
  return $application;
}

function setUpAutoloader($directoriesUp = 4) {
  if (isset($_SERVER['PATH_TRANSLATED']) && $_SERVER['PATH_TRANSLATED'] != '') {
    $path = $_SERVER['PATH_TRANSLATED'];
  } else {
    $path = $_SERVER['SCRIPT_FILENAME'];
  }
  for ($i = 0; $i < $directoriesUp; ++$i) {
    $path = dirname($path);
  }
  $path = str_replace('\\', '/', $path);
  if ('/' !== substr($path, -1)) {
    $path .= '/';
  }
  if (file_exists($path.'../papaya.php')) {
    include_once($path.'../papaya.php');
  } else {
    include_once($path.'conf.inc.php');
  }
  includeOrRedirect($path.'/../vendor/autoload.php');
}
