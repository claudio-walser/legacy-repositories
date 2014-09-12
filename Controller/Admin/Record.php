<?php
namespace Hackday\Controller\Admin;

/**
 * This class returns always a array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
class Record extends \Spaf\Core\Controller\Abstraction {

	public function setForRecording() {
		$ids = $this->_request->getParam('ids');
		return $this->_response->write('dont work yet' . print_r($ids, true));
	}
	
	/**
	 * @todo	this class/method has to be high extendable
	 */
	public function removeFromRecording() {
		$ids = $this->_request->getParam('ids');
		return $this->_response->write('dont work yet' . print_r($ids, true));
	}

}
?>