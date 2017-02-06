module Gemsy
  class NotifyWorker
    include Sidekiq::Worker

    def perform(args)
      service = Notifier.new(args)
      service.call
    end
  end
end
