module Gemsy
  class LockfileParser
    include Sidekiq::Worker

    def perform(file_path)
      content = File.read(file_path)
      parser  = Bundler::LockfileParser.new(content)
      $logger.debug parser.specs.map(&:name)
    end
  end
end
