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

  def self.define_city_command(name, options)
    define_command(name, options.merge(:context => [:city]))
  end

  # Define a command with a combination of a money requirement and money
  # payment.
  def self.define_investment(name, money, options)
    pre = options[:pre].to_a + [required_budget(money)]
    commands = options[:commands].to_a + [pay_money(money)]
    define_city_command(name, options.merge(:pre => pre, :commands => commands))
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

    define_investment "build_#{safe_name}", required_money,
      :pre => [required_space(required_space)],
      :commands => [occupy_space(required_space), construct_building(name, capacity)],
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

  define_investment "buy_space", 1000,
    :label => "buy new space",
    :message => "Space bought",
    :commands => [increase_space(1)]

  define_investment "organize_festival", 200,
    :label => "organize a festival",
    :message => "Party time!"

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
