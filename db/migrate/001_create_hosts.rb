class CreateHosts < ActiveRecord::Migration
  def self.up
    create_table :hosts do |t|
      t.string :name, :addr, :path, :user, :pass, :state, :kind, :key
      t.integer :port, :timeout, :ping, :mem, :cpu, :limit_mem, :limit_cpu, :cores
      t.text :info, :proks
      t.boolean :active, :god, :sudo, :command

      t.timestamps
    end

    add_index :hosts, :name
    add_index :hosts, :addr
    add_index :hosts, :state
  end

  def self.down
    drop_table :hosts
  end
end
