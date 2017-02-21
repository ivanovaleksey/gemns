module Gemsy
  class Lockfile
    include Mongoid::Document
    include Mongoid::Timestamps

    field :bundler,     type: String
    field :name,        type: String
    field :raw_content, type: String

    embeds_many :specs, class_name: 'Gemsy::LockfileSpec'

    def bundler_version
      Gem::Version.create(bundler)
    end
  end
end
