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

use Papaya\Utility;

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
require_once __DIR__.'/inc.conf.php';
/**
* administration interface
*/
require_once __DIR__.'/inc.func.php';

/** @var Papaya\Application\CMS $application */
$application = includeOrRedirect('./inc.application.php');

if (!($hasOptions = $application->options->loadAndDefine())) {
  $redirect = new \Papaya\Response\Redirect('install.php');
  $redirect->send(TRUE);
} elseif (
  $application->options->get('PAPAYA_UI_SECURE', FALSE) &&
  !Utility\Server\Protocol::isSecure()
) {
  $redirect = new \Papaya\Response\Redirect\Secure();
  $redirect->send(TRUE);
}

$revisionFile = Utility\File\Path::getDocumentRoot($application->options).'revision.inc.php';
if (file_exists($revisionFile) && is_readable($revisionFile)) {
  include $revisionFile;
}

$administrationUI = new \Papaya\Administration\UI($application);
$administrationUI->execute();

$PAPAYA_USER = $application->administrationUser;
$PAPAYA_LAYOUT = $administrationUI->template();

$PAPAYA_USER->layout = $PAPAYA_LAYOUT;
$PAPAYA_USER->initialize();
$application->administrationUser->execLogin();
$application->administrationPhrases->setLanguage(
  $application->languages->getLanguage(
    $application->administrationUser->options->get('PAPAYA_UI_LANGUAGE')
  )
);

$PAPAYA_LAYOUT->parameters()->assign(
  array(
    'PAGE_PROJECT' => trim(constant('PAPAYA_PROJECT_TITLE')),
    'PAGE_REVISION' => trim(constant('PAPAYA_WEBSITE_REVISION')),
    'PAPAYA_DBG_DEVMODE' => $application->options->get('PAPAYA_DBG_DEVMODE', FALSE),
    'PAPAYA_LOGINPAGE' => !$application->administrationUser->isValid,
    'PAPAYA_UI_LANGUAGE' => $application->administrationUser->options['PAPAYA_UI_LANGUAGE'],
    'PAPAYA_USE_RICHTEXT' => $application->administrationRichText->isActive(),
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

$themeHandler = new \Papaya\Theme\Handler();
$contentCss = $application->options->get('PAPAYA_RICHTEXT_CONTENT_CSS');
$localCssfile = $themeHandler->getLocalThemePath().$contentCss;
if (file_exists($localCssfile) && is_file($localCssfile)) {
  $PAPAYA_LAYOUT->parameters()->set(
    'PAPAYA_RICHTEXT_CONTENT_CSS', $themeHandler->getURL().$contentCss
  );
}

if ($application->administrationUser->isValid) {
  $PAPAYA_LAYOUT->parameters()->set('PAGE_USER', $PAPAYA_USER->user['fullname']);
  $PAPAYA_LAYOUT->add($application->administrationLanguage->getXML(), 'title-menu');
  $PAPAYA_LAYOUT->add($application->administrationRichText->getXML(), 'title-menu');
} elseif ($hasOptions) {
  $PAPAYA_LAYOUT->parameters()->set('PAGE_USER', _gt('unknown'));
} else {
  $PAPAYA_LAYOUT->parameters()->set('PAGE_USER', 'none');
}

$PAPAYA_SHOW_ADMIN_PAGE = $application->administrationUser->isValid;

ob_start('outputCompressionHandler');
header('Content-type: text/html; charset=utf-8');

