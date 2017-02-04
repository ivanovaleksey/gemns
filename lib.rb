require 'logger'
require 'sinatra'

STDOUT.sync = true
log = Logger.new(STDOUT)

get '/' do
  'GemNS is ready!'
end

post '/hook' do
  data = request.body.read
  log.debug "got webhook: #{data}"
end
