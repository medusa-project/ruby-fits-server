#Add all FITS jars and xml/nlnz directory to class path
include Java
$CLASSPATH << 'fits/xml/nlnz'
$CLASSPATH << 'fits/lib'
Dir['fits/lib/**/*.jar'].each do |jar_file|
  next if File.basename(jar_file) == 'slf4j-log4j12-1.7.12.jar' #prevent multiple bindings
  $CLASSPATH << jar_file
end
