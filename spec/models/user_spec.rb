require 'spec_helper'

describe User do
  it "should create a new instance given valid attributes" do
    lambda do
      User.create!(:email => "homer@simpson.com", :password => "D'oh?!",
        :password_confirmation => "D'oh?!")
    end.should_not raise_error
  end
end
