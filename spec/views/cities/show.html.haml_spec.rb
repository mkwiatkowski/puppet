require 'spec_helper'

describe "cities/show.html.haml" do
  it "should show city name" do
    assign(:city, Factory.stub(:city, :name => "CITY_NAME"))
    render
    rendered.should have_selector("h1", :content => "CITY_NAME")
  end

  it "should show city budget" do
    assign(:city, Factory.stub(:city, :budget => 1234))
    render
    rendered.should contain("1234")
  end
end
