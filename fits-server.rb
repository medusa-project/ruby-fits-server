#!/usr/bin/env ruby
require 'sinatra/base'
require 'open3'
require 'uri'
require 'cgi'
require 'singleton'
require_relative 'fits-fetcher'
require_relative 'fits-exceptions'

unless ENV['FITS_FILE_ROOT']
  puts "FITS_FILE_ROOT is not set - assuming absolute paths"
end

class FitsServer < Sinatra::Base
  attr_accessor :fits_home, :fits

  get '/fits/file' do
    requested_path = params['path']
    file_path = "#{ENV['FITS_FILE_ROOT']}/#{requested_path}"
    begin
      content_type :xml
      FitsFetcher.instance.find_fits_for(file_path)
    rescue FileNotFound
      status 404
      "The requested file was not found.\n"
    end
  end

  get '*' do
    status 400
    "Bad request\n"
  end

  error do
    "Unknown error\n"
  end

end
