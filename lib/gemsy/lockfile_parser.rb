require 'sidekiq'

module Gemsy
  class LockfileParser
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(file_path)
      $logger.debug 'Inside worker'
      $logger.debug "File exists? #{File.exists?(file_path)}"

      content = File.read(file_path)
      parser  = Bundler::LockfileParser.new(content)
      $logger.debug parser.specs.map(&:name)
    end
  end
end
