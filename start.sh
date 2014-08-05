#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function startRails() {
	cd $DIR
	cd rails3
	bundle exec rails server -e development &
}

function startFuseki() {
	cd $DIR
	cd fuseki
	./fuseki-server --update --mem --port=$SPARQL_PORT /ds &
	echo $! > $DIR/fuseki.pid
}

source $DIR/fuseki_config
startFuseki
startRails