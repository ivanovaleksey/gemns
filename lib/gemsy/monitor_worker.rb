module Gemsy
  class MonitorWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(args)
      Lockfile.each do |lockfile|
        service = Monitor.new(lockfile, args)
        service.call
      end
    end
  end
end
