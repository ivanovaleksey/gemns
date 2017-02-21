module Gemsy
  class LockfileParser
    def initialize(lockfile)
      @lockfile = lockfile
    end

    def call
      @lockfile.update(
        bundler: bundler,
        specs: specs
      )
    end

    private

    def bundler
      parser.bundler_version
    end

    def specs
      parser.specs.map do |spec|
        LockfileSpec.new(gem: spec.name, version: spec.version)
      end
    end

    def parser
      @parser ||= Bundler::LockfileParser.new(@lockfile.raw_content)
    end
  end
end
