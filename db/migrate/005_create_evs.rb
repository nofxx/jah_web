class CreateEvs < ActiveRecord::Migration
  def self.up
    create_table :evs do |t|
      t.references :host, :user
      t.string :name, :kind, :comm
      t.text :result
      t.boolean :sudo
      t.integer :count, :time_taken

      t.timestamps
    end
  end

  def self.down
    drop_table :evs
  end
end
