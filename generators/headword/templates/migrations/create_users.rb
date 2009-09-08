class HeadwordCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string   :username, :null => false
      t.string   :url, :null => false
      t.timestamps
    end
    add_index :users, [:url, :id]
  end

  def self.down
    drop_table :users
  end
end
