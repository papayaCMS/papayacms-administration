<?php
/**
* Login-Include
*
* @copyright 2002-2009 by papaya Software GmbH - All rights reserved.
* @link http://www.papaya-cms.com/
* @license http://www.gnu.org/licenses/old-licenses/gpl-2.0.html GNU General Public License, version 2
*
* You can redistribute and/or modify this script under the terms of the GNU General Public
* License (GPL) version 2, provided that the copyright and license notes, including these
* lines, remain unmodified. papaya is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE.
*
* @package Papaya
* @subpackage Administration
* @version $Id: inc.auth.php 39781 2014-05-05 15:43:39Z weinert $
*/

error_reporting(2047);

if (!defined('PAPAYA_ADMIN_PAGE')) {
  /**
  * This is an administration page
  * @ignore
  */
  define('PAPAYA_ADMIN_PAGE', TRUE);
}
/**
* configuration
*/
require_once("./inc.conf.php");
/**
* administration interface
*/
require_once("./inc.func.php");
/**
* images
*/
require_once('./inc.glyphs.php');

/** @var PapayaApplicationCms $application */
$application = includeOrRedirect('./inc.application.php');

if (!($hasOptions = $application->options->loadAndDefine())) {
  if (!headers_sent()) {
    redirectToInstaller();
  }
} elseif ($application->options->get('PAPAYA_UI_SECURE', FALSE) &&
          !PapayaUtilServerProtocol::isSecure()) {
  $url = 'https://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
  redirectToURL($url);
}

$application->messages->setUp($application->options);
if ($application->options->get('PAPAYA_LOG_RUNTIME_REQUEST', FALSE)) {
  PapayaRequestLog::getInstance();
}

/**
* @ignore
*/
define('PAPAYA_ADMIN_SESSION', TRUE);
$application->session->setName(
  'sid'.$application->options->get('PAPAYA_SESSION_NAME', '').'admin'
);

$application->session->options->cache = PapayaSessionOptions::CACHE_NONE;
if ($redirect = $application->session->activate(TRUE)) {
  $redirect->send();
  exit();
}
$application->pageReferences->setPreview(TRUE);

$PAPAYA_USER = $application->administrationUser;

$application->phrases = new PapayaPhrases(
  new PapayaPhrasesStorageDatabase(),
  $application->languages->getLanguage($application->options['PAPAYA_UI_LANGUAGE'])
);

if (($path = $application->options->get('PAPAYA_PATH_DATA')) != '' &&
    strpos($path, $_SERVER['DOCUMENT_ROOT']) !== FALSE &&
    file_exists($path) &&
    (!file_exists($path.'.htaccess'))) {
  $application->messages->dispatch(
    new PapayaMessageDisplay(
      PapayaMessage::SEVERITY_WARNING,
      _gt(
        'The file ".htaccess" in the directory "papaya-data/" '.
        'is missing or not accessible. Please secure the directory.'
      )
    )
  );
}
if (!$application->options->get('PAPAYA_PASSWORD_REHASH', FALSE)) {
  $application->messages->dispatch(
    new PapayaMessageDisplay(
      PapayaMessage::SEVERITY_WARNING,
      _gt(
        'The password rehashing is not active. Please activate PAPAYA_PASSWORD_REHASH.'.
        ' Make sure the authentication tables are up to date before activating'.
        ' this option, otherwise the logins can become locked.'
      )
    )
  );
}

$PAPAYA_LAYOUT = new PapayaTemplateXslt(
  dirname(__FILE__)."/skins/".$application->options->get('PAPAYA_UI_SKIN')."/style.xsl"
);

$PAPAYA_USER->layout = $PAPAYA_LAYOUT;
$PAPAYA_USER->initialize();
if ($hasOptions) {
  $PAPAYA_SHOW_ADMIN_PAGE = (bool)$PAPAYA_USER->execLogin();
} else {
  $PAPAYA_SHOW_ADMIN_PAGE = FALSE;
}

$PAPAYA_LAYOUT->parameters()->set('PAPAYA_LOGINPAGE', $PAPAYA_SHOW_ADMIN_PAGE ? FALSE : TRUE);

$projectTitle = PAPAYA_PROJECT_TITLE;

if ($PAPAYA_SHOW_ADMIN_PAGE) {
  if ((!defined('PAPAYA_WEBSITE_REVISION')) &&
      (!empty($_SERVER['DOCUMENT_ROOT']))) {

    $revisionFile = PapayaUtilFilePath::cleanup($_SERVER['DOCUMENT_ROOT']);
    $revisionFile .= $application->options->get('PAPAYA_PATH_WEB');
    $revisionFile .= 'revision.inc.php';
  } else {
    $revisionFile .= '../revision.inc.php';
  }
  if (is_readable($revisionFile)) {
    include_once($revisionFile);
  }
  if (defined('PAPAYA_WEBSITE_REVISION') && trim(PAPAYA_WEBSITE_REVISION) != '') {
    $projectTitle .= ' ('.PAPAYA_WEBSITE_REVISION.')';
  }
}
$PAPAYA_LAYOUT->parameters()->set('PAGE_PROJECT', $projectTitle);

$useRichtext = $application->session->values()->get('PAPAYA_SESS_USE_RICHTEXT');
$useRichtext = (isset($useRichtext)) ? (bool)$useRichtext : TRUE;
$PAPAYA_LAYOUT->parameters()->set(
  'PAPAYA_USE_RICHTEXT',
  isset($PAPAYA_USER->options['PAPAYA_USE_RICHTEXT']) &&
  $PAPAYA_USER->options['PAPAYA_USE_RICHTEXT'] &&
  $useRichtext
);

if (defined('PAPAYA_USE_RICHTEXT_EDITOR')) {
  $PAPAYA_LAYOUT->parameters()->set(
    'PAPAYA_USE_RICHTEXT_EDITOR', $application->options->get('PAPAYA_USE_RICHTEXT_EDITOR', TRUE)
  );
}
$PAPAYA_LAYOUT->parameters()->assign(
  array(
    'PAPAYA_RICHTEXT_TEMPLATES_FULL' =>
      $application->options->get('PAPAYA_RICHTEXT_TEMPLATES_FULL'),
    'PAPAYA_RICHTEXT_TEMPLATES_SIMPLE' =>
      $application->options->get('PAPAYA_RICHTEXT_TEMPLATES_SIMPLE'),
    'PAPAYA_RICHTEXT_LINK_TARGET' =>
      $application->options->get('PAPAYA_RICHTEXT_LINK_TARGET'),
    'PAPAYA_RICHTEXT_BROWSER_SPELLCHECK' =>
      $application->options->get('PAPAYA_RICHTEXT_BROWSER_SPELLCHECK')
  )
);

$themeHandler = new PapayaThemeHandler();
$contentCss = $application->options->get('PAPAYA_RICHTEXT_CONTENT_CSS');
$localCssfile = $themeHandler->getLocalThemePath().$contentCss;
if (file_exists($localCssfile) && is_file($localCssfile)) {
  $PAPAYA_LAYOUT->parameters()->set(
    'PAPAYA_RICHTEXT_CONTENT_CSS', $themeHandler->getUrl().$contentCss
  );
}


$PAPAYA_LAYOUT->parameters()->set(
  'PAPAYA_DBG_DEVMODE', $application->options->get('PAPAYA_DBG_DEVMODE')
);

if ($hasOptions &&
    isset($PAPAYA_USER->options['PAPAYA_UI_LANGUAGE']) &&
    $application->options['PAPAYA_UI_LANGUAGE'] != $PAPAYA_USER->options['PAPAYA_UI_LANGUAGE']) {
  $PAPAYA_LAYOUT->parameters()->set(
    'PAPAYA_UI_LANGUAGE', $PAPAYA_USER->options['PAPAYA_UI_LANGUAGE']
  );
  //user has a different ui language reset object
  $application->phrases->setLanguage(
    $application->languages->getLanguage($PAPAYA_USER->options['PAPAYA_UI_LANGUAGE'])
  );
} else {
  $PAPAYA_LAYOUT->parameters()->set(
    'PAPAYA_UI_LANGUAGE', $application->options['PAPAYA_UI_LANGUAGE']
  );
}

if ($PAPAYA_SHOW_ADMIN_PAGE) {
  if ((!defined('PAPAYA_VERSION_STRING')) && is_readable(dirname(__FILE__).'/inc.version.php')) {
    include_once(dirname(__FILE__)."/inc.version.php");
  }
  $PAPAYA_LAYOUT->parameters()->set('PAGE_USER', $PAPAYA_USER->user['fullname']);
  $PAPAYA_LAYOUT->parameters()->set(
    'PAPAYA_VERSION', defined('PAPAYA_VERSION_STRING') ? PAPAYA_VERSION_STRING : ''
  );

  initLanguageSelect();
  initRichtextSelect();
} elseif ($hasOptions) {
  $PAPAYA_LAYOUT->parameters()->set('PAGE_USER', _gt('unknown'));
} else {
  $PAPAYA_LAYOUT->parameters()->set('PAGE_USER', 'none');
}

if ((!defined('PAPAYA_VERSION_STRING'))) {
  define('PAPAYA_VERSION_STRING', '5');
}

ob_start('outputCompressionHandler');
header('Content-type: text/html; charset=utf-8');

