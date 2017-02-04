require 'logger'
require 'sinatra'

$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

module Gemsy
  autoload :Uploader, 'gemsy/uploader'
end

STDOUT.sync = true
log = Logger.new(STDOUT)

get '/' do
  'Gemsy is ready!'
end

post '/hook' do
  data = request.body.read
  log.debug "got webhook: #{data}"
end

post '/gemlock' do
  tempfile = params[:file][:tempfile]
  content  = tempfile.read

  parser = Bundler::LockfileParser.new(content)

  log.debug parser.specs.map(&:name)
end
