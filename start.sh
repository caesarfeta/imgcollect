#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function startRails() {
	cd $DIR
	cd rails3
	bundle exec rails server &
}

function startFuseki() {
	cd $DIR
	cd fuseki
	./fuseki-server --update --mem --port=8080 /ds & # <-- this is problematic
	echo $! > fuseki.pid
}

startFuseki
startRails