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

use Papaya\Request\Log;

$PAPAYA_LAYOUT->parameters()->set(
  'PAPAYA_UI_THEME', $application->options->get('PAPAYA_UI_THEME', 'green')
);
print $PAPAYA_LAYOUT->getOutput();

if ($application->options->get('PAPAYA_LOG_RUNTIME_REQUEST', FALSE)) {
  $application->database->close();
  Log::getInstance()->emit();
}

