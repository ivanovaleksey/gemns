require 'faraday'
require 'logger'
require 'sidekiq'
require 'sinatra'

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

module Gemsy
  autoload :LockfileParser, 'gemsy/lockfile_parser'
  autoload :Uploader,       'gemsy/uploader'
end

STDOUT.sync = true
$logger = Logger.new(STDOUT)

get '/' do
  'Gemsy is ready!'
end

post '/hook' do
  data = request.body.read
  $logger.debug "got webhook: #{data}"
end

post '/gemlock' do
  tempfile = params[:file][:tempfile]
  Gemsy::LockfileParser.perform_async(tempfile.path)
end
