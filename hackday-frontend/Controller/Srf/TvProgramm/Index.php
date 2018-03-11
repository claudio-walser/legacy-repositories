<?php
namespace Hackday\Controller\Srf\TvProgramm;

use Hackday\Core\ApiClient,
	Hackday\Controller\Srf\Abstraction,
	Hackday\Dto\VideoChannel,
	Hackday\Dto\Broadcast;

/**
 * This class returns always an array with the following elements:
 * success		=>		bool success, true || false
 * data			=>		mixed data, could be every datatype and contains your needed data
 */
class Index extends Abstraction {

	private $baseUrl = 'http://webservice.sf.tv/tvprogramm/';
	private $possibleChannelIds = array(
		33000,
		33001,
		33002,
		33003
	);

	public function init() {
		$this->apiClient = new ApiClient();
	}

	public function view() {
		return $this->_response->write('tvprogramm overview');
	}

	public function getChannels() {
		//http://webservice.sf.tv/tvprogramm/query/channels.xml
		$url = $this->baseUrl . 'query/channels.xml';
		$response = $this->apiClient->processUrl($url);
		$json = $this->_toJson($response);
		
		$array = json_decode($json);
		$response = array();
		foreach($array->resultSet->result as $channel) {
			if (in_array($channel->channel->channelId, $this->possibleChannelIds)) {
				$channelObject = new VideoChannel();
				$channelObject->setId($channel->channel->channelId);
				$channelObject->setName($channel->channel->name);
				array_push($response, $channelObject);
			}
		}


		return $this->_response->write($response);
	}

	public function getDayId() {
		//http://webservice.sf.tv/tvprogramm/query/tvdays.xml
		//Mon Jun 25 00:00:00 CEST 2007
		$currentDate = date('D M d 00:00:00 T Y');

		$url = $this->baseUrl . 'query/tvdays.xml';
		$response = $this->apiClient->processUrl($url);
		$json = $this->_toJson($response);
		
		$array = json_decode($json);
		$response = array();
		foreach($array->resultSet->result as $tvDay) {
			if ($tvDay->tvDay->date === $currentDate) {
				return $this->_response->write($tvDay->tvDay->dayId);
			}
		}

		return $this->_response->write(null);
	}

	public function getBroadcastByChannelIdAndDay() {
		//http://webservice.sf.tv/tvprogramm/query/broadcasts.xml?channel=33002&day=2654
		$channelId = $this->_request->getParam('channelId');
		$dayId = $this->_request->getParam('dayId');

		$url = $this->baseUrl . 'query/broadcasts.xml?channel=' . (int) $channelId . '&day=' . (int) $dayId;
		$response = $this->apiClient->processUrl($url);
		$json = $this->_toJson($response);
		
		$array = json_decode($json);
		$response = array();
		
		if (!isset($array->resultSet) || !isset($array->resultSet->result)) {
			return $this->_response->write(null);
		}
		
		foreach($array->resultSet->result as $broadcast) {
			$broadcastObject = new Broadcast();
			$broadcastObject->setId($broadcast->broadcast->program->programId);

			if (is_string($broadcast->broadcast->program->title)) {
				$broadcastObject->setTitle($broadcast->broadcast->program->title);
			}
			if (is_string($broadcast->broadcast->displayTime)) {
				$broadcastObject->setStartTime($broadcast->broadcast->displayTime);
			}
			if (is_string($broadcast->broadcast->program->subTitle)) {
				$broadcastObject->setSubTitle($broadcast->broadcast->program->subTitle);
			}
			if (is_string($broadcast->broadcast->program->link)) {
				$broadcastObject->setLink($broadcast->broadcast->program->link);
			}
			
			array_push($response, $broadcastObject);

		}
		return $this->_response->write($response);
	}

	private function _toJson($xmlString) {
		$xml = simplexml_load_string($xmlString);
		return json_encode($xml);
	}
}
?>