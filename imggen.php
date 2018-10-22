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

if ($PAPAYA_SHOW_ADMIN_PAGE &&
    $PAPAYA_USER->hasPerm(Papaya\Administration\Permissions::IMAGE_GENERATOR)) {
  $PAPAYA_LAYOUT->parameters()->set(
    'PAGE_TITLE', _gt('Administration').' - '._gt('Dynamic Images')
  );
  $PAPAYA_LAYOUT->parameters()->set('PAGE_ICON', $PAPAYA_IMAGES['items-graphic']);

  $imgGenerator = new papaya_imagegenerator();
  $imgGenerator->layout = $PAPAYA_LAYOUT;

  $imgGenerator->initialize();
  $imgGenerator->execute();
  $imgGenerator->getXML();
}
require('inc.footer.php');
