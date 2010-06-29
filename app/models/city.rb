class City < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"

  attr_accessible :name

  validates_presence_of :name, :owner

  before_save :set_defaults

  private
  def set_defaults
    self.total_space = self.free_space = 9
    self.budget = 1000
  end
end
