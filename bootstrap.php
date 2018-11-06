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

error_reporting(2047);
define('PAPAYA_ADMIN_PAGE', TRUE);

if (defined('PAPAYA_DOCUMENT_ROOT')) {
  $path = PAPAYA_DOCUMENT_ROOT;
} else {
  if (
    isset($_SERVER['PATH_TRANSLATED']) &&
    '' !== $_SERVER['PATH_TRANSLATED'] &&
    FALSE === strpos($_SERVER['PATH_TRANSLATED'], '/modsec-')
  ) {
    $path = str_replace('\\', '/', dirname(dirname($_SERVER['PATH_TRANSLATED'])));
  } else {
    $path = str_replace('\\', '/', dirname(dirname($_SERVER['SCRIPT_FILENAME'])));
  }
  if ('/' !== substr($path, -1)) {
    $path .= '/';
  }
  /**
  * Papaya document root - front controller directory on server
  * @ignore
  */
  define('PAPAYA_DOCUMENT_ROOT', $path);
}
if (file_exists($path.'../papaya.php')) {
  /** @noinspection PhpIncludeInspection */
  include_once $path.'../papaya.php';
} else {
  /** @noinspection PhpIncludeInspection */
  include_once $path.'conf.inc.php';
}

$isDevelopmentMode = defined('PAPAYA_DBG_DEVMODE') && PAPAYA_DBG_DEVMODE;
$includePapayaFile = function($fileName, $ifExistsOnly = FALSE) use ($isDevelopmentMode) {
  if ($ifExistsOnly && !(file_exists($fileName) && is_readable($fileName))) {
    return NULL;
  }
  /** @noinspection PhpIncludeInspection */
  return $isDevelopmentMode ? include $fileName : @include $fileName;
};

if (file_exists($path.'../vendor/autoload.php')) {
  $includePapayaFile($path.'../vendor/autoload.php');
} elseif (file_exists($path.'vendor/autoload.php')) {
  /** @noinspection PhpIncludeInspection */
  $includePapayaFile($path.'vendor/autoload.php');
}
$includePapayaFile(__DIR__.'/inc.glyphs.php', TRUE);
$includePapayaFile($path.'revision.inc.php', TRUE);

/** @var Papaya\Application\CMS $application */
$application = \Papaya\Application::getInstance();
$application->registerProfiles(new Papaya\Application\Profiles\CMS());
$application->request->isAdministration = TRUE;

return $application;
