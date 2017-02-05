require 'faraday'

module Gemsy
  class Uploader
    def initialize
      @conn = Faraday.new('https://gemns.herokuapp.com') do |f|
        f.request :multipart
        # f.request :url_encoded
        f.adapter :net_http
      end
    end

    def upload_gemlock
      file = Bundler.default_lockfile.to_s
      @conn.post '/gemlock', file: Faraday::UploadIO.new(file, 'plain/text'),
                             name: 'Main' # TODO: remove this stub
    end
  end
end
