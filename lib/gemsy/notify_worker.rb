require 'slack-notifier'

module Gemsy
  class NotifyWorker
    include Sidekiq::Worker

    def perform(args)
      @args = args
      $logger.debug "NOTIFY ABOUT #{@args}"
      notifier.post message
    end

    private

    def message
      {
        attachments: [
          color: 'good',
          fallback: 'Checkout latest gem updates',
          text: 'Checkout latest gem updates',
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

    def notifier
      ::Slack::Notifier.new slack_web_hook, username: 'Gemsy news'
    end

    def slack_web_hook
      ENV['SLACK_WEBHOOK']
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
