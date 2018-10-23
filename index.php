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

/** @var Papaya\Application\CMS $application */
$application = include __DIR__.'/inc.application.php';

$administrationUI = new \Papaya\Administration\UI(__DIR__, $application);
if ($response = $administrationUI->execute()) {
  ob_start('outputCompressionHandler');
  $response->send(TRUE);
}

$PAPAYA_LAYOUT = $administrationUI->template();
$PAPAYA_USER = $application->administrationUser;
