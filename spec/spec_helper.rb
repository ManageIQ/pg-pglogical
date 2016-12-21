$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pg-pglogical"
require "pg/pglogical/active_record_extension"

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV["DEBUG"]
