#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function loadLinkedData() {
	cd $DIR/fuseki
	./s-put http://localhost:8080/ds/data default $DIR/rails3/test/fixtures/collection.ttl
}

function moveImages() {
	cp -R $DIR/rails3/test/fixtures/collection_images $DIR/images/TEST
}

moveImages
loadLinkedData