class City < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  has_many :buildings

  attr_accessible :name

  validates_presence_of :name, :owner

  before_create :set_defaults
  before_save :limit_population_by_capacity

  def is_full?
    self.population == total_capacity
  end

  def total_capacity
    self.buildings.to_a.sum(&:capacity)
  end

  private
  def set_defaults
    self.total_space = 9 unless self.total_space
    self.free_space = 9 unless self.free_space
    self.budget = 1000 unless self.budget
    self.population = 0 unless self.population
  end

  def limit_population_by_capacity
    self.population = [population, total_capacity].min
  end
end
