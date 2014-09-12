<?php

/**
 * $Id$
 *
 * Demo/Core/Registry.php
 * @created Wed Sep 26 19:26:27 CET 2012
 * @author Claudio Walser
 * @reviewer TODO
 */
namespace Hackday\Core;

/**
 * Demo\Core\Registry
 *
 * Mocking of \Spaf\Core\Registry.
 *
 * @author Claudio Walser
 * @package \Spaf\tests\Mock\Core
 * @namespace \Spaf\tests\Mock\Core
 */
class Registry extends \Spaf\Core\Registry {
	
	/**
	 * Instance store
	 * 
	 * @var \Spaf\tests\Mock\Core\Registry
	 */
	private static $_instance = null;
	
	/**
	 * Private methods for beeing singleton
	 */
	private function __construct() {}
	private function __clone() {}
	
	/**
	 * mock get instance, return the mock for sure
	 * 
	 * @return \Spaf\tests\Mock\Core\Registry
	 */
	public static function getInstance(\Spaf\Core\Registry $registry = null) {
		// if instance still is NULL
		if (self::$_instance === null) {
			// create new one of myself
			self::$_instance = new self();
		}
		
		return self::$_instance;
	}
	
}

?>