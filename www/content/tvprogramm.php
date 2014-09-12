<?php
$dayId = $connector->business('Hackday\\Controller\\Srf\\TvProgramm\\Index', 'getDayId');
$dayId = $dayId['data'];

$broadcastParams = array(
	'channelId' => $_GET['channelId'],
	'dayId' => $dayId
);
$broadcasts = $connector->business('Hackday\\Controller\\Srf\\TvProgramm\\Index', 'getBroadcastByChannelIdAndDay', $broadcastParams);


if (isset($_POST)) {
	$broadcasts = $connector->business('Hackday\\Controller\\Admin\\Record', 'setForRecording', array('record' => $_POST['record']));
	$broadcasts = $connector->business('Hackday\\Controller\\Admin\\Record', 'setForRecording', array('dontRecord' => $_POST['dontRecord']));

	print_r($_POST);
}

?>
<form action="" method="post">
<?php
foreach ($broadcasts['data'] as $broadcast) {
	?>
	<div class="broadcast">
		<?php
			echo '<input type="checkbox" name="record[]" value="' . $broadcast->getId() . '" >' . $broadcast->getStartTime() . ' - <a target="_blank" href="' . $broadcast->getLink() . '">' . $broadcast->getTitle() . '</a> - ' . $broadcast->getSubtitle();
		?>
	</div>
	<?php
}
?>
<input type="submit" name="submit" value="aufnehmen" />
</form>