module Gemsy
  class Lockfile
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,        type: String
    field :raw_content, type: String

    embeds_many :specs, class_name: 'Gemsy::LockfileSpec'
  end
end
