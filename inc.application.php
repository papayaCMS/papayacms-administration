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
  define('PAPAYA_ADMIN_PAGE', TRUE);
}

require_once __DIR__.'/../../vendor/autoload.php';
require_once __DIR__.'/inc.func.php';

$revisionFile = __DIR__.'/../revision.inc.php';
if (file_exists($revisionFile) && is_readable($revisionFile)) {
  include_once __DIR__.'/../revision.inc.php';
}

/** @var Papaya\Application\CMS $application */
$application = \Papaya\Application::getInstance();
$application->registerProfiles(new Papaya\Application\Profiles\CMS());
$application->request->isAdministration = TRUE;

return $application;
