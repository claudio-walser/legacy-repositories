<?php
namespace Hackday\Dto;

/**
 * This class returns always a array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
class VideoChannel {
	
	private $_id = 0;
	private $_name = 'default name';

	public function setId($id) {
		$this->_id = (int) $id;
	}

	public function getId() {
		return $this->_id;
	}

	public function setName($name) {
		$this->_name = utf8_decode((string) $name);
	}

	public function getName() {
		return $this->_name;
	}
}
?>