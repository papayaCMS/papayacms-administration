<?php
require_once(PAPAYA_INCLUDE_PATH.'system/Papaya/Autoloader.php');
spl_autoload_register('PapayaAutoloader::load');

/** @var PapayaApplicationCms $application */
$application = PapayaApplication::getInstance();
$application->registerProfiles(new PapayaApplicationProfilesCms());

return $application;