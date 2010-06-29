require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    lambda { Factory(:user) }.should_not raise_error
  end
end
