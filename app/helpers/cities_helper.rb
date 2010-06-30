module CitiesHelper
  def city_space_summary(city)
    "#{city.total_space} (#{city.free_space})"
  end
end
