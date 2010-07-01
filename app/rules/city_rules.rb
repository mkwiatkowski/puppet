class CityRules < Command
  # Define a command that will initiate construction of a building with given
  # +name+. Resources needed for the construction should be passed via
  # :required_money and :required_space parameters.
  def self.define_build_command(name, options)
    required_money, required_space = options.values_at(:required_money, :required_space)
    if required_money.blank? or required_space.blank?
      raise ArgumentError, ":required_money and :required_space arguments are mandatory" if required_money.blank? or required_space.blank?
    end

    money_method_name = "has_at_least_#{required_money}_money"
    space_method_name = "has_at_least_#{required_space}_space"
    build_method_name = "build_#{name}!"
    define_method_once(money_method_name) do |city|
      "Not enough money to build a #{name}" if city.budget < required_money
    end
    define_method_once(space_method_name) do |city|
      "Not enough space to build a #{name}" if city.free_space < required_space
    end
    define_method_once(build_method_name) do |city|
      city.decrement!(:budget, required_money)
      city.decrement!(:free_space, required_space)
      city.buildings.create(:name => name)
    end

    define_command "build_#{name}",
      :context => [:city],
      :pre => [money_method_name, space_method_name],
      :command => build_method_name,
      :message => options[:message]
  end

  define_build_command "house",
    :required_money => 200,
    :required_space => 1,
    :message => "House built"
end
