<?php
namespace Hackday\Controller\Srf\TvProgramm;

use Hackday\Core\ApiClient,
	Hackday\Controller\Srf\Abstraction,
	Hackday\Object\VideoChannel,
	Hackday\Object\Broadcast;

/**
 * This class returns always a array with the following elements:
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
		$channelId = $this->_request->getParam('channelId');
		$dayId = $this->_request->getParam('dayId');

		//http://webservice.sf.tv/tvprogramm/query/broadcasts.xml?channel=33002&day=2654
		$url = $this->baseUrl . 'query/broadcasts.xml?channel=' . (int) $channelId . '&day=' . (int) $dayId;
		$response = $this->apiClient->processUrl($url);
		$json = $this->_toJson($response);
		
		$array = json_decode($json);
		$response = array();
		foreach($array->resultSet->result as $broadcast) {

			//echo 'WTF';
			//print_r($broadcast->broadcast->program);
			//print_r($broadcast->broadcast->program->subTitle);

			
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

/*
stdClass Object
(
    [title] => glanz & gloria
    [programId] => 113621945
    [externalId] => ed9b2041-47e6-4f15-b65f-c83c26a14818
    [subTitle] => People-Magazin
    [originalTitle] => stdClass Object
        (
        )

    [additionalTitle] => stdClass Object
        (
        )

    [leadText] => Ob glÃ¤nzende EmpfÃ¤nge in Bern oder gloriose Auftritte auf dem roten Teppich von Hollywood: Die Reporter von Â«glanz & gloriaÂ» berichten heute, worÃ¼ber die Schweiz morgen spricht. 
    [content] => stdClass Object
        (
        )

    [fsk] => stdClass Object
        (
        )

    [parental] => 0
    [link] => www.srf.ch/sendungen/glanz-und-gloria
    [linkMerchandising] => stdClass Object
        (
        )

    [linkVideo] => stdClass Object
        (
        )

    [linkEncoding] => 18037F64-E552-4772-A885-F1FD5C15DD1E
    [productionCountry] => CH
    [shortHint] => Â«glanz & gloriaÂ», das tÃ¤gliche Magazin Ã¼ber die angesagtesten Promis, Partys und Events.


    [year] => 2014
    [images] => stdClass Object
        (
            [image] => stdClass Object
                (
                    [imageId] => 58950693
                    [externalId] => aa3ac7cf-f903-4459-8837-8375aee94518
                    [description] => (Copyright SRF/Oscar Alessio)
                    [makePublic] => true
                    [title] => Moderatorin Nicole Berchtold
                )

        )

    [genres] => stdClass Object
        (
            [genre] => stdClass Object
                (
                    [genreId] => 600000
                    [name] => Unterhaltung
                )

        )

    [stories] => stdClass Object
        (
        )

    [persons] => stdClass Object
        (
            [person] => stdClass Object
                (
                    [personId] => 185543403
                    [externalId] => c048e680-3325-4c1e-98f0-d2e8f1f4139e
                    [realName] => Nicole Berchtold
                    [role] => Moderation:
                    [bracket] => stdClass Object
                        (
                        )

                )

        )

    [attributesAudio] => stdClass Object
        (
            [attribute] => stdClass Object
                (
                    [attributeId] => 1
                    [name] => Mono Dual
                    [iconName] => monodual
                    [translation] => stdClass Object
                        (
                        )

                )

        )

    [attributesVideo] => stdClass Object
        (
            [attribute] => Array
                (
                    [0] => stdClass Object
                        (
                            [attributeId] => 5
                            [name] => Wiederholung
                            [iconName] => rerun
                            [translation] => stdClass Object
                                (
                                )

                        )

                    [1] => stdClass Object
                        (
                            [attributeId] => 261
                            [name] => UT
                            [iconName] => ut
                            [translation] => stdClass Object
                                (
                                )

                        )

                    [2] => stdClass Object
                        (
                            [attributeId] => 262
                            [name] => TXT UT
                            [iconName] => txt_ut
                            [translation] => stdClass Object
                                (
                                )

                        )

                    [3] => stdClass Object
                        (
                            [attributeId] => 256
                            [name] => Farbe
                            [iconName] => color
                            [translation] => stdClass Object
                                (
                                )

                        )

                    [4] => stdClass Object
                        (
                            [attributeId] => 257
                            [name] => 4:3 Vollbild Format
                            [iconName] => 4_3
                            [translation] => stdClass Object
                                (
                                )

                        )

                )

        )

)*/

			//print_r($broadcast->broadcast->program);
			
		}
		return $this->_response->write($response);
	}

	private function _toJson($xmlString) {
		$xml = simplexml_load_string($xmlString);
		return json_encode($xml);
	}
}
?>