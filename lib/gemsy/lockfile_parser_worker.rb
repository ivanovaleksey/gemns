module Gemsy
  class LockfileParserWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(lockfile_id)
      lockfile = Lockfile.find(lockfile_id)
      service  = LockfileParser.new(lockfile)
      service.call
    end
  end
end
