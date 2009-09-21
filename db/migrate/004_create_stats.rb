class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.references :host
      t.integer :cpu, :mem, :temp
      t.string :value, :net, :cpus, :disks, :temps
      t.text :proks

      t.timestamps
    end

    add_index :stats, :host_id
    add_index :stats, :cpu
    add_index :stats, :mem
    add_index :stats, :temp
  end

  def self.down
    drop_table :stats
  end
end
