module Gemsy
  class Monitor
    def initialize(lockfile, args)
      @lockfile = lockfile
      @args = args
    end

    def call
      $logger.debug("Call monitor for lockfile: #{@lockfile}, with args: #{@args}")

      spec = @lockfile.specs.find_by(gem: gem)
      $logger.debug(spec.inspect)
      return unless spec

      notify_about(spec) if should_notify_about?(spec)
    end

    private

    def notify_about(spec)
      notify_args = { gem: gem, old_version: spec.version.to_s, new_version: new_version }
      NotifyWorker.perform_async(notify_args)
    end

    def should_notify_about?(spec)
      Gem::Version.create(spec.version) < Gem::Version.create(new_version)
    end

    def gem
      @args[:gem] || @args['gem']
    end

    def new_version
      @args[:version] || @args['version']
    end
  end
end
