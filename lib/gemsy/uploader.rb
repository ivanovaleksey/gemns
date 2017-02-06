require 'faraday'

module Gemsy
  class Uploader
    def initialize(args)
      @args = args
      @conn = Faraday.new('https://gemns.herokuapp.com') do |f|
        f.request :multipart
        # f.request :url_encoded
        f.adapter :net_http
      end
      @conn.basic_auth(ENV['GEMSY_USERNAME'], ENV['GEMSY_PASSWORD'])
    end

    def upload_gemlock
      @conn.post '/gemlock', file: Faraday::UploadIO.new(@args[:file], 'plain/text'),
                             name: @args[:name]
    end
  end
end
