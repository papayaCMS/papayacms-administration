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
* Authentication
*/
require_once("./inc.auth.php");


if ($PAPAYA_SHOW_ADMIN_PAGE) {
  $moduleName = '';
  $pattern = '(/module_(?P<module>[^/.?#]+)\.php(?:[?#]|$))';
  if (
    isset($_SERVER['REQUEST_URI']) &&
    preg_match($pattern, $_SERVER['REQUEST_URI'], $matches)
  ) {
    $moduleName = \Papaya\Utility\Arrays::get($matches, 'module');
  }

  $module = new papaya_editmodules($moduleName);
  $module->layout = $PAPAYA_LAYOUT;

  $module->initialize();
  $module->execute();
}
require('inc.footer.php');
