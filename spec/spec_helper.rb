$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pg/pglogical"
require "pg/pglogical/active_record_extension"

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["DEBUG"]

RSpec.configure do |config|
  config.around do |example|
    pool = ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :database => "pg_pglogical_test",
      :pool     => 1
    )
    pool.connection.transaction do
      begin
        example.call
      ensure
        raise ActiveRecord::Rollback
      end
    end
  end
end
