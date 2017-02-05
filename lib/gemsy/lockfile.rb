require 'mongoid'

module Gemsy
  class Lockfile
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,        type: String
    field :raw_content, type: String
  end
end
