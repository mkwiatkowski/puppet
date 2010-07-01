require 'spec_helper'

describe Building do
  it "should require a name" do
    Factory.build(:building, :name => nil).should_not be_valid
  end

  describe "with a name" do
    before do
      @building = Factory(:building)
    end

    it "should be valid" do
      @building.should be_valid
    end
  end
end
