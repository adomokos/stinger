module Stinger
  class Client < ActiveRecord::Base
    has_many :assets
  end
end
