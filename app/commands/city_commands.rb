class CityCommands < Command
  def self.required_budget(amount)
    lambda do |city|
      "Not enough money" if city.budget < amount
    end
  end

  def self.required_space(amount)
    lambda do |city|
      "Not enough space" if city.free_space < amount
    end
  end

  def self.pay_money(amount)
    lambda do |city|
      city.decrement!(:budget, amount)
    end
  end

  def self.increase_space(amount)
    lambda do |city|
      city.increment!(:free_space, amount)
      city.increment!(:total_space, amount)
    end
  end

  def self.occupy_space(amount)
    lambda do |city|
      city.decrement!(:free_space, amount)
    end
  end

  def self.construct_building(name, capacity)
    lambda do |city|
      city.buildings.create(:name => name, :capacity => capacity)
    end
  end

  # Define a command that will initiate construction of a building with given
  # +name+. Resources needed for the construction should be passed via
  # :required_money and :required_space parameters.
  def self.define_build_command(name, options)
    safe_name = name.sub(/ /, '_')
    capacity = options[:capacity] || 0
    required_money, required_space = options.values_at(:required_money, :required_space)
    if required_money.blank? or required_space.blank?
      raise ArgumentError, ":required_money and :required_space arguments are mandatory"
    end

    define_command "build_#{safe_name}",
      :context => [:city],
      :pre => [required_budget(required_money), required_space(required_space)],
      :commands => [pay_money(required_money), occupy_space(required_space), construct_building(name, capacity)],
      :message => options[:message],
      :label => "build a #{name}"
  end

  TAX_RATE = 0.05

  # Progress game by a single step. Should be called by cron in regular
  # time intervals.
  def self.tick!
    City.all.each do |city|
      city.increment!(:population) unless city.is_full?
      city.increment!(:budget, (city.population * TAX_RATE).round)
    end
  end

  define_command "buy_space",
    :context => [:city],
    :pre => [required_budget(1000)],
    :label => "buy new space",
    :message => "Space bought",
    :commands => [pay_money(1000), increase_space(1)]

  define_command "organize_festival",
    :context => [:city],
    :pre => [required_budget(200)],
    :label => "organize a festival",
    :message => "Party time!",
    :commands => [pay_money(200)]

  define_build_command "small house",
    :required_money => 90,
    :required_space => 1,
    :capacity => 6,
    :message => "House built"

  define_build_command "medium house",
    :required_money => 200,
    :required_space => 1,
    :capacity => 15,
    :message => "House built"

  define_build_command "big house",
    :required_money => 450,
    :required_space => 2,
    :capacity => 36,
    :message => "House built"
end
