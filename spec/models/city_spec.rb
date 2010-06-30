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
  end

  describe "with some free space" do
    before do
      @city = Factory(:city)
      @city.free_space.should > 0
    end

    it "should be able to build a house" do
      @city.build_house!
    end

    it "should lower the free space by one after building a house" do
      lambda { @city.build_house! }.should change(@city, :free_space).by(-1)
    end

    it "should lower the budget by 200 after building a house" do
      lambda { @city.build_house! }.should change(@city, :budget).by(-200)
    end
  end

  describe "without any free space" do
    before do
      @city = Factory(:city, :free_space => 0)
      @city.free_space.should == 0
    end

    it "should not be able to build a house" do
      lambda { @city.build_house! }.should raise_error(UserActionError,
        "not enough space to build a house")
    end

    it "should not lower the free space after trying to build a house" do
      lambda {
        begin
          @city.build_house!
        rescue UserActionError
          nil
        end
      }.should_not change(@city, :free_space)
    end
  end
end
