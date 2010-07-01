class City < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  has_many :buildings

  attr_accessible :name

  validates_presence_of :name, :owner

  before_create :set_defaults

  private
  def set_defaults
    self.total_space = 9 unless self.total_space
    self.free_space = 9 unless self.free_space
    self.budget = 1000 unless self.budget
  end
end
