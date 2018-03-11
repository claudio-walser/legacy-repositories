<?php
namespace Hackday\Controller;

/**
 * This class returns always a array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
class Index extends \Spaf\Core\Controller\Abstraction {

	public function view() {

		return $this->_response->write('demo index controller');
	}
	
	/**
	 * @todo	this class/method has to be high extendable
	 */
	public function test() {
		return $this->_response->write('demo test controller');
	}

}
?>