module Stinger
  class Client < ActiveRecord::Base
    # has_many :assets
    # has_many :vulnerabilities

    def assets
      Stinger::Sharded::Asset.using(shard_name).all
    end

    def vulnerabilities
      Stinger::Sharded::Vulnerability.using(shard_name).all
    end

    private

    def shard_name
      Stinger::Sharded::Utils.shard_name_for(id)
    end
  end
end
