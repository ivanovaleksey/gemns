require 'sinatra/base'
require 'json'

module Gemsy
  class Listener < Sinatra::Base
    class Unauthorized < StandardError; end

    get '/' do
      'Gemsy is ready!'
    end

    post '/hook' do
      begin
        data = request.body.read
        hash = JSON.parse(data)
        $logger.debug("Hook params: #{hash}")

        authorize_web_hook(env, hash)
        MonitorWorker.perform_async(gem: hash['name'], version: hash['version'])
      rescue Unauthorized
        $logger.info "Unauthorized: #{env['HTTP_AUTHORIZATION']}"
        error 401
      end
    end

    post '/gemlock' do
      $logger.debug "got gemfile: #{params.inspect}"

      tempfile = params[:file][:tempfile]
      lockfile = Lockfile.find_or_initialize_by(name: params[:name])
      lockfile.update(raw_content: tempfile.read)

      Gemsy::LockfileParser.perform_async(lockfile.id)
    end

    private

    def authorize_web_hook(env, params)
      authorization = [params['name'], params['version'], ENV['RUBYGEMS_API_KEY']].join('')
      raise Unauthorized if env['HTTP_AUTHORIZATION'] != Digest::SHA2.hexdigest(authorization)
    end
  end
end
