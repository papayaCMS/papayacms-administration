<?php
require_once(PAPAYA_DOCUMENT_ROOT.'../vendor/autoload.php');

/** @var PapayaApplicationCms $application */
$application = PapayaApplication::getInstance();
$application->registerProfiles(new PapayaApplicationProfilesCms());

return $application;