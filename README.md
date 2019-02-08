## Introduction

This is a very simple web service that wraps the FITS
file identification tool. You'll need to install ruby/gems
as per the .rvmrc and Gemfile. FITS is included as a git submodule, so
after cloning this repository do a:

    git submodule init
    git submodule update

FITS will then be installed in the fits subdirectory. 

##Installation

If desired, set FITS\_FILE\_ROOT to a directory relative to which
the request paths will be interpreted. If this is not set we
assume that passed paths descend from '/'.

JAVA_7_HOME must be set to the home of java 7 (required by FITS 0.8.3). Note that
java 8 will not work.

Start the server with:

	./start.sh

Stop it with

    ./stop.sh

The thin server running the ruby sinatra application runs on port 4567 by default. 

You can edit fits-server.yml to set other options. It runs as a rack
application under Thin (made clear by the above scripts), so see Thin
docs for additional settings that may be available.

##Services

If one of these is not matched then a 400 is returned.

Currently available:

###GET on /fits/file

Pass one parameter, path. This will be interpreted relative to the
base path.

This will find, on the server, FITS_FILE_ROOT/path and
run FITS against it, returning the FITS XML.

If the file is not found a 404 is raised.

If the local FITS does not return successfully then a 500 is raised.

## Message server version

In the config you must set up one or more medusa_storage roots, and may designate one
of them as a default. In addition, you may want to set a tmp_dir to designate a temporary
directory to use (possibly necessary if you will be doing large files and the system
tmpdir can't handle them).

Uses our simple_queue_server framework. Config in config/ruby-fits-server-amqp.yaml.
Most important is the content.root, from which the client and server will
communicate the relative paths to files. The action is 'fits', the parameters hash
has a single required key, 'path', with this relative path. In addition the parameters 
hash may contain a 'root' key to designate the storage root to be used.
 
On success the return parameters
hash will have a 'fits_xml' key with the fits xml (as well as the standard return of
the action again, the pass_through as given, and status as 'success').

The most common failure would be a file not found, which would have status 'failure'
and message 'File not found' (and the action and pass_through).
 


