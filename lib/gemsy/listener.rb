require 'sinatra/base'

module Gemsy
  class Listener < Sinatra::Base
    configure :production do
      require 'newrelic_rpm'
      require 'rack/contrib/post_body_content_type_parser'

      use Rack::PostBodyContentTypeParser
    end

    helpers do
      def authorize_lockfile
        auth = Rack::Auth::Basic::Request.new(request.env)
        credentials = [ENV['GEMSY_USERNAME'], ENV['GEMSY_PASSWORD']]
        return if auth.provided? && auth.basic? && auth.credentials && auth.credentials == credentials
        not_authorized('Gemsy')
      end

      def authorize_web_hook
        authorization = [params[:name], params[:version], ENV['RUBYGEMS_API_KEY']].join('')
        return if env['HTTP_AUTHORIZATION'] == Digest::SHA2.hexdigest(authorization)
        not_authorized
      end

      def not_authorized(realm = 'Restricted Area')
        $logger.info "Unauthorized: #{env['HTTP_AUTHORIZATION']}"
        headers['WWW-Authenticate'] = "Basic realm=#{realm}"
        error 401
      end
    end

    get '/' do
      'Gemsy is ready!'
    end

    post '/hook' do
      $logger.debug("Hook params: #{params}")
      authorize_web_hook

      MonitorWorker.perform_async(gem: params['name'], version: params['version'])
    end

    post '/gemlock' do
      $logger.debug "Got gemfile: #{params}"
      authorize_lockfile

      tempfile = params[:file][:tempfile]
      lockfile = Lockfile.find_or_initialize_by(name: params[:name])
      lockfile.update(raw_content: tempfile.read)

      Gemsy::LockfileParser.perform_async(lockfile.id)
    end
  end
end
