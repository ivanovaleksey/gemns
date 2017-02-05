module Gemsy
  class LockfileParser
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(lockfile_id)
      lockfile = Lockfile.find(lockfile_id)

      parser = Bundler::LockfileParser.new(lockfile.raw_content)
      specs  = parser.specs.map do |spec|
        LockfileSpec.new(gem: spec.name, version: spec.version.to_s)
      end
      lockfile.update(specs: specs)
    end
  end
end
