#!/bin/sh

addgroup nginx www-data

su - fcgiwrap -s /bin/sh -c "
  umask 002
  fcgiwrap -s unix:/var/run/fcgiwrap/socket
" &
