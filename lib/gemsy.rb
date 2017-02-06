require 'logger'
require 'mongoid'
require 'sidekiq'

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__))

module Gemsy
  autoload :Error,             'gemsy/error'
  autoload :UnauthorizedError, 'gemsy/error'

  autoload :Listener,       'gemsy/listener'
  autoload :Lockfile,       'gemsy/lockfile'
  autoload :LockfileParser, 'gemsy/lockfile_parser'
  autoload :LockfileSpec,   'gemsy/lockfile_spec'
  autoload :Monitor,        'gemsy/monitor'
  autoload :MonitorWorker,  'gemsy/monitor_worker'
  autoload :NotifyWorker,   'gemsy/notify_worker'
  autoload :Uploader,       'gemsy/uploader'
end

STDOUT.sync = true
$logger = Logger.new(STDOUT)
