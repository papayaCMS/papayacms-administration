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

function includeFile($file) {
  return include $file;
}

/**
* initialize object for a dynamic popup page
*
* @return boolean
*/
function initializeAdministrationPage() {
  error_reporting(2047);
  $path = dirname(dirname(dirname(dirname(__DIR__))));
  define('PAPAYA_DOCUMENT_ROOT', dirname($path).'/');
  includeFile($path.'/inc.conf.php');
  $application = includeFile($path.'/inc.application.php');
  $options = $application->options;
  $options->loadAndDefine();
  $application->messages->setUp($application->options);
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
