<?php
/**
*
*
* @copyright 2002-2007 by papaya Software GmbH - All rights reserved.
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
* @subpackage Scripts-Controls
* @version $Id: inc.controls.php 39824 2014-05-20 08:31:38Z weinert $
*/


use Papaya\Application\Cms;

if (!defined('PAPAYA_DOCUMENT_ROOT')) {
  if (isset($_SERVER['PATH_TRANSLATED']) && $_SERVER['PATH_TRANSLATED'] != '') {
    $path = strtr(dirname(dirname(dirname(dirname($_SERVER['PATH_TRANSLATED'])))), '\\', '/');
  } else {
    $path = strtr(dirname(dirname(dirname(dirname($_SERVER['SCRIPT_FILENAME'])))), '\\', '/');
  }
  if (substr($path, -1) != '/') {
    $path .= '/';
  }
  /**
   * @ignore
   */
  define('PAPAYA_DOCUMENT_ROOT', $path);
}
if (!defined('PAPAYA_ADMIN_PAGE')) {
  /**
  * @ignore
  */
  define('PAPAYA_ADMIN_PAGE', TRUE);
}
/**
* inclusion of base or additional libraries
*/
require_once(dirname(__FILE__).'/../../inc.conf.php');
require_once(dirname(__FILE__).'/../../inc.func.php');

/** @var Cms $application */
$application = include_once(dirname(__FILE__).'/../../inc.application.php');
$application->options->loadAndDefine();
$application->messages->setUp($application->options);

/**
* @ignore
*/
define('PAPAYA_ADMIN_SESSION', TRUE);
if (defined('PAPAYA_SESSION_NAME')) {
  $application->session->setName('sid'.PAPAYA_SESSION_NAME.'admin');
} else {
  $application->session->setName('sidadmin');
}
$application->options->cache = PapayaSessionOptions::CACHE_PRIVATE;
$application->session->activate(FALSE);
$application->phrases = new PapayaPhrases(
  new PapayaPhrasesStorageDatabase(),
  $application->languages->getLanguage($application->options['PAPAYA_UI_LANGUAGE'])
);

$PAPAYA_USER = $application->getObject('AdministrationUser');
$PAPAYA_USER->layout = $PAPAYA_LAYOUT = new PapayaTemplateXslt(
  dirname(__FILE__)."/../../skins/".$application->options->get('PAPAYA_UI_SKIN')."/style.xsl"
);
$PAPAYA_USER->initialize();

$PAPAYA_SHOW_ADMIN_PAGE = (bool)$PAPAYA_USER->execLogin();
if (!$PAPAYA_SHOW_ADMIN_PAGE) {
  exit;
} elseif (
  isset($PAPAYA_USER->options['PAPAYA_UI_LANGUAGE']) &&
  PAPAYA_UI_LANGUAGE != $PAPAYA_USER->options['PAPAYA_UI_LANGUAGE']) {
  //user has a different ui language reset object
  $application->phrases->setLanguage(
    $application->languages->getLanguage($PAPAYA_USER->options['PAPAYA_UI_LANGUAGE'])
  );
}
$application->session->close();


$PAPAYA_SKIN = $application->options->get('PAPAYA_UI_SKIN', 'default');

header('Content-type: text/html; charset=utf-8');

