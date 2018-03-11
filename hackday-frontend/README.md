The srf-video-recorder on raspberry-pi
=======================

This repository contains a web-ui, used to setup recording SRF livestreams.
Should be runable on a raspberry pi, recording is done with a python deamon.
You can find the python-daemon repository here: https://github.com/claudio-walser/hackday-python

## Dependencies
 - PHP >= 5.4
 - PHP MySQLi
 - PHP cURL
 - PHP SimpleXml
 - Spaf Framework - https://github.com/claudiowalser/Spaf

## Installation
...


TODO
----

- Fix HD Suisse API call
- Make UI more fancy - Maybe a javascript only frontend instead of that ugly php/html mix - since all controller can be called with ajax very easily
- Overview of recorded videos with a search and delete option
- Implement calendar to browse more than one day
- Delete recordings
- Record series
- Make proposals on whats already recorded
- Make proposals by mostClicked Videos from intlayer
- Make it multi user capable
- If its multi user and has a friend system, make proposals from what my friends recorded
- BEAUTIFY ALL THE STUFF
- CACHING, CACHING, CACHING...
