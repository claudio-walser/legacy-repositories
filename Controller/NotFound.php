<?php

namespace Hackday\Controller;

/**
 * This class returns always a array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
class NotFound extends \Spaf\Core\Controller\Abstraction {

	public function view() {

		return $this->_response->write('demo not found controller');
	}
	
}
?>