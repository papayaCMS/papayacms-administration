<?php
require_once('../../vendor/autoload.php');

/** @var PapayaApplicationCms $application */
$application = PapayaApplication::getInstance();
$application->registerProfiles(new PapayaApplicationProfilesCms());

return $application;