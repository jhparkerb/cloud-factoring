#!/bin/sh

set -e

# createuser -S -D -R -l -e -w -U postgres ecmnet
psql -U ecmnet -c "alter user ecmnet with password 'ecmpassword';"

# createdb -e -O ecmnet -E UNICODE -U postgres ecmnet
