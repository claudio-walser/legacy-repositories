<?php
/**
 * $ID$
 *
 * Autoloader.php test
 */

namespace Hackday;

// load Spaf\Autoloader, YOU HAVE TO
require_once('../../Spaf/src/Spaf/Core/Autoloader.php');
 
/**
 * Autoloader class
 * For new packages/libraries, just define your own autoloader method
 * and add it to Autoloader::register().
 *
 * @author		Claudio Walser
 */
final class Autoloader extends \Spaf\Core\Autoloader {

	/**
	 * Autoloader for the Cwa Framework classes
	 *
	 * @param		String		Classname with complete namespace
	 * @return		boolean
	 */
	public function Spaf($name) {
		$file = $this->_getFilename($name);
		$file = '../../Spaf/src/' . $file;
		
		if (is_file($file) && is_readable($file)) {
			// do debug message if needed
			$this->debug('<strong>' . date('Y-m-d H:i:s') . '</strong> -- File ' . $file . ' successfully loaded' . "<br />\n");
			// require the file
			require_once($file);
			return true;
		} else {
			$this->debug('<strong>' . date('Y-m-d H:i:s') . '</strong> -- File ' . $file . ' not found; include_path:' . get_include_path() . "<br />\n");
			return false;
		}
	}

	/**
	 * Autoloader for the Cwa Framework classes
	 *
	 * @param		String		Classname with complete namespace
	 * @return		boolean
	 */
	public function Hackday($name) {
		$file = $this->_getFilename($name);
		$file = '../../' . $file;
		
		if (is_file($file) && is_readable($file)) {
			// do debug message if needed
			$this->debug('<strong>' . date('Y-m-d H:i:s') . '</strong> -- File ' . $file . ' successfully loaded' . "<br />\n");
			// require the file
			require_once($file);
			return true;
		} else {
			$this->debug('<strong>' . date('Y-m-d H:i:s') . '</strong> -- File ' . $file . ' not found; include_path:' . get_include_path() . "<br />\n");
			return false;
		}
	}

}
?>