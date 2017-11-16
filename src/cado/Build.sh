#!/bin/sh

set -e
set -x

for dir in build base single server client
do
	docker build -t cado-${dir} ${dir}
done
