#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function stopRails() {
	cd $DIR
	file="rails3/tmp/pids/server.pid"
	pid=`cat ${file}`
	kill $pid
	rm $file
}

function stopFuseki() {
	cd $DIR
	file="${DIR}/fuseki.pid"
	pid=`cat ${file}`
	kill $pid
	rm $file
}

stopRails
stopFuseki