#!/bin/bash

SCRIPT_DIR=`dirname $0`
export FITS_HOME=$SCRIPT_DIR/fits

bundle exec passenger stop --port 4567 --pid-file tmp/pids/ruby-fits-server.pid
#thin -C fits-server.yml -R config.ru stop
