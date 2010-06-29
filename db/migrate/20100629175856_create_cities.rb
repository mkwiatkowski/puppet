class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.belongs_to :owner, :null => false
      t.string :name, :null => false
      t.integer :free_space, :null => false
      t.integer :total_space, :null => false
      t.integer :budget, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :cities
  end
end
