class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :null => false
      t.string :state
      t.integer :hosts_count, :null => false, :default => 0

      t.timestamps
    end

    create_table :groups_users, :id => false do |t|
      t.references :group, :user
    end

    create_table :groups_hosts, :id => false do |t|
      t.references :group, :host
    end

    add_index :groups, :name
    add_index :groups_users, :group_id
    add_index :groups_users, :user_id
    add_index :groups_users, [:group_id, :user_id]
  end

  def self.down
    drop_table :groups
  end
end
