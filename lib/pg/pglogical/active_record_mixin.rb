require "pg/pglogical"

module PG
  module Pglogical
    module ActiveRecordMixin
      def pglogical
        PG::Pglogical::Client.new(self)
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include PG::Pglogical::ActiveRecordMixin
