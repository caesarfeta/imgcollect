#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function stopRails() {
	cd $DIR
	file="${DIR}/rails3/tmp/pids/server.pid"
	pid=`cat ${file}`
	kill $pid
}

function stopFuseki() {
	cd $DIR
	file="${DIR}/fuseki.pid"
	pid=`cat ${file}`
	kill $pid
}

stopRails
stopFuseki