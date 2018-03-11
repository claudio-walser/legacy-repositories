<?php
include('bootstrap.php');
?>

<html>
<head>
	<title>Stream Recorder</title>
	<style>
	.channel-nav {
		list-style: none;
	}
	.channel-nav li {
		float: left;
	}
	.channel-nav a {
		text-decoration: none;
		font-weight: bold;
		padding: 5px;
		width: 100px;
		text-align: center;
		display: block;
		color: #000;
	}
	.channel-nav a.active {
		color: #fff;
		background-color: #af001e;
	}

	.clear {
		clear: both;
	}

	.content {
		padding: 150px;
		padding-top: 0px;
	}

	.content h1 {
		font-size: 25px;
		font-weight: bold;
	}
	</style>
</head>
<body>
	<?php
	include_once('layout/header.php');
	?>
	<div class="content">
		<?php
		include_once('content/tvprogramm.php');
		?>
	</div>
</body>



