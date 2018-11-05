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
  $url .= 'install';
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
