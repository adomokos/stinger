class CreateToTest < ActiveRecord::Migration[5.0]
  using_all_shards

  def up
    create_table :to_test do |t|
      t.integer :client_id, :null => false
      t.timestamps :null => false
    end
  end

  def down
    drop_table :to_test
  end
end
