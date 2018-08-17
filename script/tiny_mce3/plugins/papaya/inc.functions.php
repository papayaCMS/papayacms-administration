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
* PHP functions for the tinymce popups.
*
* @package Papaya
* @subpackage Administration-TinyMCE
*/

/**
* initialize object for a dynamic popup page
*
* @return boolean
*/
function initializeAdministrationPage() {
  error_reporting(2047);
  if (!defined('PAPAYA_ADMIN_PAGE')) {
    define('PAPAYA_ADMIN_PAGE', TRUE);
  }
  $path = dirname(dirname(dirname(dirname(dirname($_SERVER['SCRIPT_FILENAME'])))));
  if (file_exists($path.'/../../papaya.php')) {
    include_once($path.'/../../papaya.php');
  } else {
    include_once($path.'/../conf.inc.php');
  }
  define('PAPAYA_DOCUMENT_ROOT', dirname($path).'/');
  include_once($path.'/inc.func.php');
  $application = include_once($path.'/inc.application.php');
  $options = $application->options;
  if (!$options->loadAndDefine()) {
    if (defined('PAPAYA_DBG_DATABASE_ERROR') && PAPAYA_DBG_DATABASE_ERROR) {
      redirectToInstaller();
    }
  }
  $application->messages->setUp($application->options);
  include_once(PAPAYA_INCLUDE_PATH.'system/base_auth.php');
  if (defined('PAPAYA_SESSION_NAME')) {
    $application->session->setName('sid'.PAPAYA_SESSION_NAME.'admin');
  } else {
    $application->session->setName('sidadmin');
  }
  $application->session->options->cache = \Papaya\Session\Options::CACHE_PRIVATE;
  $application->session->activate(FALSE);
  $user = $application->administrationUser;
  $user->initialize();
  return $user->execLogin();
}
