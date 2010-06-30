require 'spec_helper'

describe CitiesController do
  include Devise::TestHelpers

  before do
    @user = Factory(:user)
    sign_in @user
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      @city = Factory(:city, :owner => @user)
      get 'show', :id => @city.id
      response.should be_success
    end
  end
end
