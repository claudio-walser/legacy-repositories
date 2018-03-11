<?php
namespace Hackday\Controller\Srf;

use Hackday\Core\ApiClient;
/**
 * This class returns always a array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
abstract class Abstraction extends \Spaf\Core\Controller\Abstraction {

	protected $integrationLayerCompanyUnits = array(
		'srf',
		'rts',
		'rsi',
		'rtr',
		'swi'
	);


	protected function _checkCompanyUnit($ue) {
		if (!in_array($ue, $this->integrationLayerCompanyUnits)) {
			throw new Exception('UE ' . $ue . ' not allowed');
		}
	}
}
?>