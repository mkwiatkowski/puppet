module CitiesHelper
  def city_space_summary(city)
    "#{city.free_space} / #{city.total_space}"
  end

  def city_population_summary(city)
    "#{city.population} / #{city.total_capacity}"
  end
end
