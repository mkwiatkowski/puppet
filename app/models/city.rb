class City < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"

  attr_accessible :name

  validates_presence_of :name, :owner

  before_create :set_defaults

  def build_house!
    raise UserActionError.new("not enough space to build a house") if free_space.zero?
    self.decrement!(:budget, 200)
    self.decrement!(:free_space)
  end

  private
  def set_defaults
    self.total_space = 9 unless self.total_space
    self.free_space = 9 unless self.free_space
    self.budget = 1000 unless self.budget
  end
end
