#!/bin/bash

set -x
set -u

DIGITS=${1:-150}

D=$(mktemp -d -p ~/tmp)

function to_bits() {
	# l(10)/l(2) ~ 3.22
	echo $(( $1 * 322 / 100 ))
}

function prime() {
	set +x
	openssl prime -generate -safe -bits $(to_bits $1)
	set -x
}

prime_digits=$(( DIGITS / 2 ))
N=$(echo $(prime $prime_digits) \* $(prime $prime_digits) |
	BC_LINE_LENGTH=1000 bc)

num_cpus=$(nproc)

time \
	docker run \
		--cpuset-cpus 0-$((num_cpus - 1)) \
		--rm \
		-it \
		-v ${D}:/home/cado cado:latest \
			/pkg/cado/bin/cado-nfs.py -w . \
				${N} \
				;
