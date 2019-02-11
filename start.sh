#!/bin/bash

SCRIPT_DIR=`dirname $0`
unset FITS_HOME

mkdir -p tmp/pids

#start ruby server
bundle install
bundle exec passenger start --port 4567 --environment production --log-file log/ruby-fits-server.log --pid-file tmp/pids/ruby-fits-server.pid &
#thin -C fits-server.yml -R config.ru start
