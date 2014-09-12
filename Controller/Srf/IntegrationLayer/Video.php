<?php
namespace Hackday\Controller\Srf\IntegrationLayer;

use Hackday\Core\ApiClient;
/**
 * This class returns always a array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
class Video extends \Spaf\Core\Controller\Abstraction {

	private $tld = 'http://il.srf.ch';
	private $integrationLayerBaseUrl = '/integrationlayer/1.0/ue/';
	private $integrationLayerUes = array(
		'srf',
		'rts',
		'rsi',
		'rtr',
		'swi'
	);

	public function init() {
		$this->apiClient = new ApiClient($this->tld);
	}
	
	/**
	 * @todo	this class/method has to be high extendable
	 */
	public function getMostClicked($ue = 'srf') {
		//http://il.srf.ch/integrationlayer/1.0/ue/srf/video/mostClicked.xml

		$this->_checkCompanyUnit($ue);

		$url = $this->tld . $this->integrationLayerBaseUrl . $ue . '/video/mostClicked.json';
		$xmlResponse = $this->apiClient->processUrl($url);
		$xml = new \SimpleXMLElement($xmlResponse);

		return $this->_response->write($xmlResponse);
	}

	public function getVideoDetail($ue = 'srf') {
		//http://il.srf.ch/integrationlayer/1.0/ue/srf/video/detail/8fa5f4d2-c35d-44e1-af27-c69cb9bc6019
		$this->_checkCompanyUnit($ue, $videoId);

		$url = $this->tld . $this->integrationLayerBaseUrl . $ue . '/video/detail/' . $videoId;
		$xmlResponse = $this->apiClient->processUrl($url);
		$xml = new \SimpleXMLElement($xmlResponse);

		return $this->_response->write($xmlResponse);
	}


	private function _checkCompanyUnit($ue) {
		if (!in_array($ue, $this->integrationLayerUes)) {
			throw new Exception('UE ' . $ue . ' not allowed');
		}
	}
}
?>