<?php
$dayId = $connector->business('Hackday\\Controller\\Srf\\TvProgramm\\Index', 'getDayId');
$dayId = $dayId['data'];

$broadcastParams = array(
	'channelId' => isset($_GET['channelId']) ? $_GET['channelId'] : null,
	'dayId' => $dayId
);
$broadcasts = $connector->business('Hackday\\Controller\\Srf\\TvProgramm\\Index', 'getBroadcastByChannelIdAndDay', $broadcastParams);


if (isset($_POST['record'])) {
	$addToRecord = $connector->business('Hackday\\Controller\\Admin\\Record', 'setForRecording', array('record' => $_POST['record']));
}


if ($broadcasts['success'] !== false) {
	?>
	<form action="" method="post">
		<?php
		foreach ($broadcasts['data'] as $broadcast) {
			?>
			<div class="broadcast">
				<?php
					$startTime = $broadcast->getStartTime();
					$disabled = '';
					$isRecording = $connector->business('Hackday\\Controller\\Admin\\Record', 'isRecording', array('id' => $broadcast->getId()));
					$checked = $isRecording['success'] === true ? 'checked' : '';
					/*if (strpos(':', $startTime) !== false) {
						$parts = explode(':', $startTime);
						$hour = (int) $parts[0];
						$minutes = (int) $parts[1];
						$disabled = 'disabled="true"';
						if ($hour >= date('H')) {
							$disabled = '';
						} else {
							echo $startTime . ' kleiner als ' . date('H:i');
						}
					}*/
					echo '<input type="checkbox" ' . $disabled . ' ' . $checked . ' name="record[]" value="' . $broadcast->getId() . '" />' . 
						  $startTime . ' - <a target="_blank" href="' . $broadcast->getLink() . '">' . $broadcast->getTitle() .
						  '</a> - ' . $broadcast->getSubtitle() . 
						  '<input type="hidden" name="token[' . $broadcast->getId() . ']" value="dont-know-yet-' . $broadcast->getId() .'" />' . 
						  '<input type="hidden" name="title[' . $broadcast->getId() . ']" value="' . $broadcast->getTitle() .'" />' . 
						  '<input type="hidden" name="subtitle[' . $broadcast->getId() . ']" value="' . $broadcast->getSubtitle() .'" />';
				?>
			</div>
			<?php
		}
		?>
		<input type="submit" name="submit" value="aufnehmen" />
	</form>
	<?php
}
?>