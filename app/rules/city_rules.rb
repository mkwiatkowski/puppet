class CityRules < Command
  def has_free_space?(city)
    "Not enough space to build a house" if city.free_space.zero?
  end

  def has_enough_money?(city)
    "Not enough money to build a house" if city.budget < 200
  end

  def build_house!(city)
    city.decrement!(:budget, 200)
    city.decrement!(:free_space)
  end

  define_command "build_house",
    :context => [:city],
    :pre => [:has_free_space?, :has_enough_money?],
    :message => "House built",
    :command => :build_house!
end
