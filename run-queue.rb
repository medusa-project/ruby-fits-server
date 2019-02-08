#!/usr/bin/env ruby
require_relative 'fits-queue-server'

#only run if given run as the first argument. This is useful for letting us load this file
#in irb to work with things interactively when we need to
FitsQueueServer.new(config_file: 'config/ruby-fits-server-queue.yaml').run if ARGV[0] == 'run'
