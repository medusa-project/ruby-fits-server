require_relative 'fits-java'
require_relative 'fits-exceptions'

#This basically exists to wrap the creation of the Fits object, which take a long time
#We then make sure it is instantiated at start up
class FitsFetcher
  include Singleton
  attr_accessor :fits

  def initialize
    fits_home = File.join(File.dirname(__FILE__), 'fits')
    self.fits = Java::EduHarvardHulOisFits.Fits.new(fits_home)
  end

  def find_fits_for(file_path)
    raise FileNotFound unless File.exist?(file_path)
    begin
      fits_output = FitsFetcher.instance.fits.examine(java.io.File.new(file_path))
      return Java::OrgJdomOutput.XMLOutputter.new.output_string(fits_output.get_fits_xml)
    rescue Exception => e
      raise RuntimeError, "Error running FITS locally: #{e}"
    end
  end

end
FitsFetcher.instance