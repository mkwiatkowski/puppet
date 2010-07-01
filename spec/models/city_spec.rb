require 'spec_helper'

describe City do
  it "should require a name" do
    Factory.build(:city, :name => nil).should_not be_valid
  end

  describe "with a name" do
    before do
      @city = Factory(:city)
    end

    it "should be valid" do
      @city.should be_valid
    end

    it "should have a default total and free space of 9" do
      @city.total_space.should == 9
      @city.free_space.should == 9
    end

    it "should have a budget of 1000" do
      @city.budget.should == 1000
    end

    it "should have a population of 0" do
      @city.population.should == 0
    end
  end
end
