<?php
/**
 * $ID$
 *
 * Autoloader.php test
 */

namespace Hackday;
 
 use Spaf\Core;
/**
 * Autoloader class
 * For new packages/libraries, just define your own autoloader method
 * and add it to Autoloader::register().
 *
 * @author		Claudio Walser
 */
final class Connector {

	private $business = null;
	private $request = null;
	private $response = null;

	public function __construct() {
		$this->request = new Core\Request\Http();
		$this->response = new Core\Response\Php();

		$this->business = new Core\Application();
		$this->business->setResponse($this->response);
		$this->business->setRequest($this->request);

		$this->business->setNotFoundController('Hackday\\Controller\\NotFound');
		$this->business->setDefaultController('Hackday\\Controller\\Index');
		$this->business->setDefaultAction('view');
	}

	public function business($controller = 'Hackday\\Controller\\Index', $action = 'view', $params = array()) {
		

		$_REQUEST['controller'] = $controller;
		$_REQUEST['action'] = $action;

		if (!empty($params)) {
			foreach ($params as $key => $value) {
				$_REQUEST[$key] = $value;
			}
		}

		return $this->business->run();
	}

	public function setMySQLi(\MySQLi $db) {
		$registry = Core\Registry::getInstance();
		$registry->set('mysqli', $db, true);
	}

}
?>