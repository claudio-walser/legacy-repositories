<?php

use Hackday\Autoloader,
	Hackday\Connector;

/**
 * setup the error reporting
 */
error_reporting(E_ALL);
ini_set('display_errors', true);


/**
 * get the autoloader
 */
require_once('../Autoloader.php');
$autoloader = new Autoloader();
$connector = new Connector();

?>