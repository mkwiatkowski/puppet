class AddCapacityToBuildings < ActiveRecord::Migration
  def self.up
    add_column :buildings, :capacity, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :buildings, :capacity
  end
end
