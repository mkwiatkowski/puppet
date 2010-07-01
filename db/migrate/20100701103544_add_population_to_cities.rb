class AddPopulationToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :population, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :cities, :population
  end
end
