require 'slack-notifier'

module Gemsy
  class Notifier
    def initialize(args)
      @args = args
    end

    def call
      $logger.debug "Notify with: #{@args}"
      notifier.post message
    end

    private

    def notifier
      ::Slack::Notifier.new slack_web_hook, username: 'Gemsy news'
    end

    def message
      {
        attachments: [
          color: 'good',
          fallback: fallback_text,
          text: 'Checkout latest gem updates!',
          fields: [
            {
              'title': 'Gemfile',
              'value': lockfile,
              'short': true
            },
            {
              'title': 'Gem',
              'value': rubygems_link,
              'short': true
            },
            {
              'title': 'Old version',
              'value': old_version,
              'short': true
            },
            {
              'title': 'New version',
              'value': new_version,
              'short': true
            }
          ]
        ]
      }
    end

    def slack_web_hook
      ENV['SLACK_WEBHOOK']
    end

    def fallback_text
      format('%{gem} gem has been updated', gem: gem)
    end

    def rubygems_link
      format('<https://rubygems.org/gems/%{gem}|%{gem}>', gem: gem)
    end

    def lockfile
      @args[:lockfile] || @args['lockfile']
    end

    def gem
      @args[:gem] || @args['gem']
    end

    def old_version
      @args[:old_version] || @args['old_version']
    end

    def new_version
      @args[:new_version] || @args['new_version']
    end
  end
end
