require "pg/pglogical"
require "active_record"
require "active_record/connection_adapters/postgresql_adapter"

module PG
  module Pglogical
    module ActiveRecordExtension
      def pglogical
        PG::Pglogical::Client.new(self)
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include PG::Pglogical::ActiveRecordExtension
