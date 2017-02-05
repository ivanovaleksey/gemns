require 'logger'

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

module Gemsy
  autoload :Listener,       'gemsy/listener'
  autoload :LockfileParser, 'gemsy/lockfile_parser'
  autoload :Uploader,       'gemsy/uploader'
end

STDOUT.sync = true
$logger = Logger.new(STDOUT)
