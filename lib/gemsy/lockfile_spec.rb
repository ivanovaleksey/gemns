module Gemsy
  class LockfileSpec
    include Mongoid::Document
    include Mongoid::Timestamps

    field :gem,     type: String
    field :version, type: String

    embedded_in :lockfile
  end
end
