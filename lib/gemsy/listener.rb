require 'sinatra/base'

module Gemsy
  class Listener < Sinatra::Base
    get '/' do
      'Gemsy is ready!'
    end

    post '/hook' do
      data = request.body.read
      $logger.debug "got webhook: #{data}"
    end

    post '/gemlock' do
      $logger.debug "got gemfile: #{params.inspect}"

      tempfile = params[:file][:tempfile]
      lockfile = Lockfile.find_or_initialize_by(name:params[:name])
      lockfile.update(raw_content: tempfile.read)

      Gemsy::LockfileParser.perform_async(lockfile.id)
    end
  end
end
