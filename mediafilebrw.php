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

use Papaya\Administration\Permissions;

/**
* Authentication
*/
require_once("./inc.auth.php");


if ($PAPAYA_SHOW_ADMIN_PAGE &&
    $PAPAYA_USER->hasPerm(Permissions::FILE_BROWSE)) {

  $PAPAYA_LAYOUT->parameters()->set('PAGE_TITLE', _gt('Mediafile browser'));

  $mediaDB = new papaya_mediadb_browser;
  $mediaDB->dataDirectory = $application->options->get('PAPAYA_PATH_MEDIAFILES');
  $mediaDB->thumbnailDirectory = $application->options->get('PAPAYA_PATH_THUMBFILES');
  $mediaDB->layout = $PAPAYA_LAYOUT;

  $mediaDB->initialize();
  $mediaDB->getXML();

} else {
  $PAPAYA_LAYOUT->parameters()->set('PAGE_TITLE', 'Mediafile browser');
}
require('inc.footer.php');
