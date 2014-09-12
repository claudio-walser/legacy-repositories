<?php

use SpafExample\Autoloader,
	Spaf\Core;

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

$request = new Core\Request\Http();
$response = new Core\Response\Json();

// you could store $request/$response in the registry with keys request/response
// as well, Spaf\Core\Main is trying to fetch those in the constructor
$business = new Core\Main();
$business->setRegistry(\SpafExample\Core\Registry::getInstance());

// or inject it naturally and visible
$business->setResponse($response);
$business->setRequest($request);

$business->setNotFoundController('SpafExample\\Controller\\NotFound');
$business->setDefaultController('SpafExample\\Controller\\Index');
$business->setDefaultAction('view');

// outputs json
$business->run();

?>