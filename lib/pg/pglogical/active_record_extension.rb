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

    module MigrationExtension
      def drop_table(table, options = {})
        table_string = table.to_s

        pgl = PG::Pglogical::Client.new(ApplicationRecord.connection)
        if pgl.enabled?
          pgl.replication_sets.each do |set|
            pgl.replication_set_remove_table(set, table_string) if pgl.tables_in_replication_set(set).include?(table_string)
          end
        end
        super
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include PG::Pglogical::ActiveRecordExtension
ActiveRecord::Migration.prepend PG::Pglogical::MigrationExtension
