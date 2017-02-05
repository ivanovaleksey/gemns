require 'sidekiq'

module Gemsy
  class LockfileParser
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(lockfile_id)
      $logger.debug 'Inside worker'
      $logger.debug lockfile_id

      lockfile = Lockfile.find(lockfile_id)
      $logger.debug lockfile.inspect

      parser  = Bundler::LockfileParser.new(lockfile.raw_content)
      $logger.debug parser.specs.map(&:name)
    end
  end
end
