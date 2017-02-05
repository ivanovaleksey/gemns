require 'sinatra/base'
require 'securerandom'

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
      file = File.open(SecureRandom.uuid, 'w') { |io| io << tempfile.read }

      $logger.debug "Temp exists? #{File.exists?(tempfile.path)}"
      $logger.debug file.path
      $logger.debug "File exists? #{File.exists?(file.path)}"

      Gemsy::LockfileParser.perform_async(file.path)
    end
  end
end
