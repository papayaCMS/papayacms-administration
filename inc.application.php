<?php

use Papaya\Application\Cms;
use Papaya\Application\Profiles\Cms;

require_once(PAPAYA_DOCUMENT_ROOT.'../vendor/autoload.php');

/** @var Cms $application */
$application = PapayaApplication::getInstance();
$application->registerProfiles(new Cms());

return $application;
