require 'simple_queue_server'
require_relative 'fits-fetcher'
require_relative 'fits-exceptions'
require 'medusa_storage'

class FitsQueueServer < SimpleQueueServer::Base

  attr_accessor :requests_served, :storage_roots, :default_root, :tmp_dir_picker

  def initialize(args = {})
    super
    self.default_root = Settings.medusa_storage.default_root
    self.storage_roots = MedusaStorage::RootSet.new(Settings.medusa_storage.roots.to_a)
    initialize_tmp_dir_picker
    self.requests_served = 0
  end

  def handle_fits_request(interaction)
    key = interaction.request_parameter('path')
    root = storage_roots.at(interaction.request_parameter('root') || default_root)
    self.logger.info "Computing FITS for: #{key} for root: #{root.name}"
    raise FileNotFound unless root.exist?(key)
    tmp_dir = (self.tmp_dir_picker.pick(size(key)) rescue Dir.tmpdir)
    root.with_input_file(key, tmp_dir: tmp_dir) do |f|
      fits_xml = FitsFetcher.instance.find_fits_for(f)
      interaction.succeed(fits_xml: fits_xml, fits_computed: true)
    end
  rescue FileNotFound
    interaction.fail_generic("File not found")
  ensure
    self.requests_served = self.requests_served + 1
    java.lang.System.gc if (self.requests_served % 25).zero?
  end

  def initialize_tmp_dir_picker
    tmp_dir_picker_config = ((Settings.tmp_dir_picker || Array.new) rescue Array.new)
    self.tmp_dir_picker = MedusaStorage::TmpDirPicker.new(tmp_dir_picker_config)
  end
  
end
