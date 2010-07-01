require 'spec_helper'

describe CitiesController do
  include Devise::TestHelpers

  def assign_city(city)
    controller.stub!(:retrieve_city)
    controller.instance_variable_set("@city", city)
  end

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

  describe "for a certain city" do
    before do
      @city = Factory(:city, :owner => @user)
    end

    describe "show" do
      it "should be successful" do
        get 'show', :id => @city.id
        response.should be_success
      end
    end

    describe 'manage' do
      describe "without any parameters" do
        before do
          @params = {:id => @city.id}
        end
        it "should redirect to city page" do
          post 'manage', @params
          response.should redirect_to(city_path(@city))
        end

        it "should show an alert flash" do
          post 'manage', @params
          flash[:alert].should == "Unknown action"
        end
      end

      describe "with build_house command" do
        before do
          @params = {:id => @city.id, :command => "build_house"}
        end

        it "should redirect to city page" do
          post 'manage', @params
          response.should redirect_to(city_path(@city))
        end

        it "should build a house" do
          assign_city(@city)
          CityCommands.should_receive(:handle!).with("build_house", :city => @city).
            and_return(stub("command", :message => ""))
          post 'manage', @params
        end

        it "should show a notice flash" do
          post 'manage', @params
          flash[:notice].should == "House built"
        end
      end
    end
  end
end
