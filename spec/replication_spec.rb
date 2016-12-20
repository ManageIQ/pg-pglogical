describe "pglogical replication" do
  let(:source_db_name)       { "pg_pglogical_test" }
  let(:target_db_name)       { "pg_pglogical_test_target" }
  let(:source_dsn)           { "dbname=#{source_db_name}" }
  let(:target_dsn)           { "dbname=#{target_db_name}" }

  let(:replication_set_name) { "test_rep_set" }
  let(:sub_name)             { "test_subscription" }

  let(:tables) do
    %w(included1 included2 excluded1 excluded2)
  end

  let(:included_tables) do
    %w(included1 included2)
  end

  let(:target_connection) do
    class ::TargetDb < ActiveRecord::Base; end
    TargetDb.establish_connection(
      :adapter  => "postgresql",
      :database => target_db_name
    ).connection
  end

  let(:source_connection) do
    ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :database => source_db_name
    ).connection
  end

  before do
    create_tables
    enable_nodes
  end

  def create_tables
    tables.each do |t|
      [source_connection, target_connection].each do |conn|
        conn.select_value(<<-SQL)
          CREATE TABLE IF NOT EXISTS #{t} (
            id   SERIAL PRIMARY KEY,
            data VARCHAR(50)
          )
        SQL
      end
    end
  end

  def enable_nodes
    source_connection.pglogical.enable
    target_connection.pglogical.enable

    source_connection.pglogical.node_create("source_node", source_dsn)
    target_connection.pglogical.node_create("target_node", target_dsn)

    source_connection.pglogical.replication_set_create(replication_set_name)
    included_tables.each do |t|
      source_connection.pglogical.replication_set_add_table(replication_set_name, t)
    end
  end

  after do
    Object.send(:remove_const, :TargetDb) if defined? TargetDb
    source_connection.pglogical.replication_set_drop(replication_set_name)
    source_connection.pglogical.node_drop("source_node")
    target_connection.pglogical.node_drop("target_node")
  end

  it "replicates" do
    insert_start = 0

    # Test that rows are replicated initially on subscription create
    insert_records
    target_connection.pglogical.subscription_create(sub_name, source_dsn, [replication_set_name], false)

    # add a block so that we can be sure we try to clean up the subscription
    # otherwise existing replication connections will prevent us from removing
    # the test target database
    begin
      sleep(5)
      assert_records_replicated

      # Test subscription info methods
      sub_info = target_connection.pglogical.subscription_show_status(sub_name)
      expect(sub_info["subscription_name"]).to eq(sub_name)
      expect(sub_info["status"]).to eq("replicating")
      expect(sub_info["provider_dsn"]).to eq(source_dsn)
      expect(sub_info["replication_sets"]).to eq([replication_set_name])

      sub_list = target_connection.pglogical.subscriptions
      expect(sub_list.first).to eq(sub_info)

      # Test that rows are replicated as they are inserted when there is an active subscription
      insert_records
      sleep(5)
      assert_records_replicated

      # Test that no changes are replicated through a disabled subscription
      target_connection.pglogical.subscription_disable(sub_name)
      insert_records
      assert_records_not_replicated

      # Test that previous changes are replicated through a re-enabled subscription
      target_connection.pglogical.subscription_enable(sub_name)
      sleep(5)
      assert_records_replicated

    ensure
      # Drop the subscription and make sure no more rows are replicated
      target_connection.pglogical.subscription_drop(sub_name)
      insert_records
      assert_records_not_replicated
    end
  end

  def insert_records
    included_tables.each do |t|
      2.times do
        source_connection.select_value(<<-SQL)
          INSERT INTO #{t} (data) VALUES ('super random data')
        SQL
      end
    end
  end

  # Asserts that for all tables in the given list the table is either
  # excluded and has no rows in the target or is included and the
  # target has the same number of rows as the source
  def assert_records_replicated
    tables.each do |t|
      expected = included_tables.include?(t) ? row_count(source_connection, t) : 0
      got      = row_count(target_connection, t)
      expect(got).to eq(expected), "on table: #{t}\nexpected: #{expected}\n     got: #{got}"
    end
  end

  # asserts that there are more rows on the source than the target for
  # non-excluded tables in the given list
  def assert_records_not_replicated
    included_tables.each do |t|
      source_count = row_count(source_connection, t)
      target_count = row_count(target_connection, t)
      expect(source_count).to be > target_count, "on table: #{t}\nexpected: #{source_count} > #{target_count}\n"
    end
  end

  def row_count(connection, table)
    connection.select_value(<<-SQL).to_i
      SELECT COUNT(*) FROM #{connection.quote_table_name(table)}
    SQL
  end
end
