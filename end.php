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

if (!defined('PAPAYA_ADMIN_PAGE')) {
  /**
  * This is an administration page
  * @ignore
  */
  define('PAPAYA_ADMIN_PAGE', TRUE);
}

require_once("./inc.conf.php");
require_once("./inc.func.php");

/** @var \Papaya\Application\Cms $application */
$application = includeOrRedirect(dirname(__FILE__).'/inc.application.php');

if (!($hasOptions = $application->options->loadAndDefine())) {
  if (defined('PAPAYA_DBG_DATABASE_ERROR') && PAPAYA_DBG_DATABASE_ERROR) {
    redirectToInstaller();
  }
} elseif (defined('PAPAYA_UI_SECURE') &&
          PAPAYA_UI_SECURE &&
          !\Papaya\Utility\Server\Protocol::isSecure()) {
  $url = 'https://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
  redirectToURL($url);
}

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
$locking = papaya_locking::getInstance();
$locking->removeLocks($application->session->id);

$application->session->options->cache = \Papaya\Session\Options::CACHE_NONE;
$application->session->activate(FALSE);
$application->session->destroy();

$PAPAYA_USER = $application->getObject('AdministrationUser');
$PAPAYA_USER->initialize();
$PAPAYA_USER->execLogin();

$protocol = \Papaya\Utility\Server\Protocol::get();
$url = $protocol.'://'.$_SERVER['HTTP_HOST'].
  str_replace('\\', '/', dirname($_SERVER['PHP_SELF'])).'/';
redirectToURL($url);
