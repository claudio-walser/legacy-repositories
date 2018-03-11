<?php
$channels = $connector->business('Hackday\\Controller\\Srf\\TvProgramm\\Index', 'getChannels');
?>
<ul class="channel-nav">
<?php
foreach ($channels['data'] as $channel) {
	$class = '';
	if (isset($_GET['channelId']) && (int) $_GET['channelId'] === $channel->getId()) {
		$class = 'active';
	}
	echo '<li><a class="' . $class . '" href="?channelId=' . $channel->getId() . '">' . $channel->getName() . '</a></li>';
}
?>
</ul>
<div class="clear"></div>
