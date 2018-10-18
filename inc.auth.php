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

$PAPAYA_USER->layout = $administrationUI->template();
$PAPAYA_USER->initialize();
$application->administrationUser->execLogin();
$application->administrationPhrases->setLanguage(
  $application->languages->getLanguage(
    $application->administrationUser->options->get('PAPAYA_UI_LANGUAGE')
  )
);

$PAPAYA_SHOW_ADMIN_PAGE = $application->administrationUser->isValid;

