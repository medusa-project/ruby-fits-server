require './fits-server.rb'
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      FitsFetcher.instance
    end
  end
end
run FitsServer