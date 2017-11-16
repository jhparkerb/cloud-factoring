#!/bin/sh

set -e

export N=${1-N}
su -c '/pkg/cado/bin/cado-nfs.py $(cat $N)' cado
