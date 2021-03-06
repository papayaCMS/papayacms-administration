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

$runAtBrowser = FALSE;
$runAtConsole = FALSE;
$verbose = TRUE;

$path = str_replace('\\', '/', dirname(__DIR__));
$outputQueue = '';
$jobId = 0;

if (
  empty($_SERVER['DOCUMENT_ROOT']) &&
  isset($_SERVER['argv']) &&
  is_array($_SERVER['argv']) &&
  count($_SERVER['argv']) > 0 &&
  in_array(PHP_SAPI, array('cli', 'cgi'))
) {
  //called from cmdline - check for path param
  foreach ($_SERVER['argv'] as $param) {
    if (FALSE !== strpos($param, '--path=')) {
      $path = str_replace('\\', '/', substr($param, 7));
    }
    if (FALSE !== strpos($param, '--quiet')) {
      $verbose = FALSE;
    }
    if (FALSE !== strpos($param, '--job=')) {
      $jobId = (int)substr($param, 6);
    }
  }
  $runAtConsole = TRUE;
} elseif (
  isset($_SERVER['SCRIPT_FILENAME']) &&
  file_exists($_SERVER['SCRIPT_FILENAME'])
) {
  //called from webbrowser
  $path = str_replace('\\', '/', dirname(dirname($_SERVER['SCRIPT_FILENAME'])));
  $runAtBrowser = TRUE;
} else {
  echo 'Invalid environment. No browser or command line?'."\n";
  exit;
}
//trailing slash
if ('/' !== substr($path, -1)) {
  $path .= '/';
}
if (file_exists($path) && is_dir($path)) {
  /**
  * Papaya document root - front controller directory on server
  * @ignore
  */
  define('PAPAYA_DOCUMENT_ROOT', $path);
  if ($verbose) {
    $outputQueue .= 'Using path: '.htmlspecialchars(PAPAYA_DOCUMENT_ROOT)."\n";
  }
} else {
  echo 'Can not use path: '.htmlspecialchars($path.'/')."\n";
  exit;
}

/** @var \Papaya\Application\CMSApplication $application */
$application = include __DIR__.'/bootstrap.php';
$options = $application->options;

/**
* Optionen
*/
if ($verbose) {
  $outputQueue .= 'Loading options.'."\n";
}
if ($options->loadAndDefine()) {
  if ($verbose) {
    $outputQueue .= 'Options loaded.'."\n";
  }
} else {
  echo $outputQueue;
  echo 'Can not load options.'."\n";
  exit;
}

if ($runAtBrowser && isset($_GET['job']) && $_GET['job'] > 0) {
  //executed from backend - init session and backend user
  if (defined('PAPAYA_SESSION_NAME')) {
    $application->session->setName('sid'.PAPAYA_SESSION_NAME.'admin');
  } else {
    $application->session->setName('sidadmin');
  }
  $application->session->options->cache = \Papaya\Session\Options::CACHE_NONE;
  if ($redirect = $application->session->activate(TRUE)) {
    $redirect->send();
    exit();
  }
}

if ($runAtBrowser) {
  header('Content-Type: text/plain');
}
/* the message is a little bit late, but we have to start the session if needed */
echo $outputQueue;
$outputQueue = '';

if ($runAtBrowser) {
  if (defined('PAPAYA_BROWSER_CRONJOBS') &&
      defined('PAPAYA_BROWSER_CRONJOBS_IP') && PAPAYA_BROWSER_CRONJOBS) {
    $ipAddresses = preg_split('(\s*,\s*)', trim(PAPAYA_BROWSER_CRONJOBS_IP));
    if (
      isset($_SERVER['REMOTE_ADDR']) &&
      \Papaya\Filter\Factory::isIpAddress($_SERVER['REMOTE_ADDR'], TRUE)) {
      $remoteAddress = $_SERVER['REMOTE_ADDR'];
    } else {
      $remoteAddress = NULL;
    }
    if (
      in_array('0.0.0.0', $ipAddresses, TRUE) ||
      (isset($remoteAddress) && in_array($remoteAddress, $ipAddresses, TRUE))
    ) {
      if ($verbose) {
        echo 'Called from: '.htmlspecialchars($remoteAddress)."\n";
      }
    } else {
      echo 'Invalid access from: '.htmlspecialchars($remoteAddress)."\n";
      exit;
    }
  } else {
    echo 'Invalid access.'."\n";
    exit;
  }
} elseif ($verbose) {
  echo 'Called from console.'."\n";
}

if ($verbose) {
  echo "Initialize logging.\n";
}

$application->messages->setUp($options);

if ($verbose) {
  echo "Initialize session and pidfile.\n";
}

if ($verbose) {
  echo 'Start ('.date('Y-m-d H:i:s').").\n";
}
try {
  $pid = new \pidfile(constant('PAPAYA_PATH_CACHE').'papaya_cron.pid');
  if ($pid->execute($verbose)) {
    $cron = new \base_cronjobs;

    if ($runAtBrowser &&
        isset($_GET['job']) && $_GET['job'] > 0) {
      $PAPAYA_USER = new \base_auth();
      $PAPAYA_USER->initialize();
      if ($PAPAYA_USER->execLogin() &&
          $PAPAYA_USER->hasPerm(\Papaya\CMS\Administration\Permissions::SYSTEM_CRONJOBS)) {
        if ($verbose) {
          echo 'Job id: '.(int)$_GET['job']."\n";
        }
        if ($cronJobId = $cron->checkJob($_GET['job'], FALSE)) {
          if ($verbose) {
            echo "Job loaded.\n";
          }
          $cron->executeJob($cronJobId, $verbose);
        } else {
          echo 'Not found.'."\n";
        }
      } else {
        echo 'Invalid user'."\n";
      }
    } elseif ($runAtConsole && $jobId) {
      if ($verbose) {
        echo 'Job id: '.$jobId."\n";
      }
      if ($cronJobId = $cron->checkJob($jobId, TRUE)) {
        if ($verbose) {
          echo "Job loaded.\n";
        }
        $cron->executeJob($cronJobId, $verbose);
      } else {
        echo 'Not found or not active.'."\n";
      }
    } elseif ($cronJobId = $cron->getNext()) {
      if ($verbose) {
        echo 'Job id: '.$cronJobId."\n";
      }
      $cron->executeJob($cronJobId, $verbose);
    }
    if ($verbose) {
      echo 'End ('.date('Y-m-d H:i:s').").\n";
    }
    $pid->delete();
    return 0;
  }
  if ($verbose) {
    echo "Second Instance. Stop.\n";
  }
  return 1;
} catch (LogicException $e) {
  echo $e->getMessage();
  return 1;
}
