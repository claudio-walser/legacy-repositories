<?php
namespace Hackday\Controller\Admin;

/**
 * This class returns always a array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
class Record extends \Spaf\Core\Controller\Abstraction {

	private $_db = null;

	public function init() {
		$this->_db = $this->_registry->get('mysqli');
	}

	public function isRecording() {
		$id = $this->_request->getParam('id');
		$query = "SELECT * FROM recording WHERE id=" . $this->_db->real_escape_string($id);
		$result = $this->_db->query($query);
		return $this->_response->write($result->num_rows);
	}

	public function setForRecording() {
		$ids = $this->_request->getParam('record');
		if (!empty($ids)) {
			foreach ($ids as $id) {
				// ugly access to superglobals, have to fix that in Core\Request, even i dont think its good to pass array-values by post request
				$query = "INSERT INTO recording SET 
					id = " . $this->_db->real_escape_string($id) . ",
					token = '" . $this->_db->real_escape_string($_POST['token'][$id]) . "',
					state = 'waiting',
					file = '',
					title = '" . $this->_db->real_escape_string($_POST['title'][$id]) . "',
					subtitle = '" . $this->_db->real_escape_string($_POST['subtitle'][$id]) . "'
				";
				$this->_db->query($query);
			}
		}
		
		return $this->_response->write('dont work yet' . print_r($ids, true));
	}
	
	/**
	 * @todo	this class/method has to be high extendable
	 */
	public function removeFromRecording() {
		$ids = $this->_request->getParam('dontRecord');
		return $this->_response->write('not implemented yet');
	}

}
?>