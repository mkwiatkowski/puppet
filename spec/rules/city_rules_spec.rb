require 'spec_helper'

describe CityRules do
  def build_house!
    Command.handle!("build_house", :city => @city)
  end

  def house_building_ignoring_errors
    lambda {
      begin
        build_house!
      rescue UserActionError
        nil
      end
    }
  end

  describe "for a city with some free space" do
    before do
      @city = Factory(:city)
      @city.free_space.should > 0
    end

    it "should be able to build a house" do
      build_house!
    end

    it "should lower the free space by one after building a house" do
      lambda { build_house! }.should change(@city, :free_space).by(-1)
    end

    it "should lower the budget by 200 after building a house" do
      lambda { build_house! }.should change(@city, :budget).by(-200)
    end
  end

  describe "for a city without enough budget" do
    before do
      @city = Factory(:city, :budget => 100)
      @city.budget.should < 200
    end

    it "should not be able to build a house" do
      lambda { build_house! }.should raise_error(UserActionError,
        "Not enough money to build a house")
    end

    it "should not lower the budget after trying to build a house" do
      house_building_ignoring_errors.should_not change(@city, :budget)
    end
  end

  describe "for a city without any free space" do
    before do
      @city = Factory(:city, :free_space => 0)
      @city.free_space.should == 0
    end

    it "should not be able to build a house" do
      lambda { build_house! }.should raise_error(UserActionError,
        "Not enough space to build a house")
    end

    it "should not lower the free space after trying to build a house" do
      house_building_ignoring_errors.should_not change(@city, :free_space)
    end
  end

  describe "build_house command" do
    it "should create a new building with a name 'house' in the city" do
      @city = Factory(:city)
      lambda {
        build_house!
      }.should change(@city.buildings, :size).from(0).to(1)
      @city.buildings.first.name.should == 'house'
    end
  end
end
