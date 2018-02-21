class DropToTest < ActiveRecord::Migration[5.0]
  using_all_shards

  def up
    drop_table :to_test
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
