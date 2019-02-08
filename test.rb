#!/usr/bin/env ruby
#This is an example of how we might use the Java API to handle this
#It works except that it can't seem to use the NLNZ tool this way -
#the other tools work fine.
#Don't forget to switch the rvmrc back to jrbuy if you want to work on this
include Java

Dir["fits/lib/**/*.jar"].each do |jar|
  $CLASSPATH << jar
end
$CLASSPATH << "fits/lib"
$CLASSPATH << "fits/xml/nlnz"

#puts $CLASSPATH

fits_home = File.join(Dir.pwd, 'fits')
fits = Java::EduHarvardHulOisFits.Fits.new(fits_home)
fits_output = fits.examine(java.io.File.new(File.join(Dir.pwd, 'test.rb')))

puts Java::OrgJdomOutput.XMLOutputter.new.output_string(fits_output.get_fits_xml)
