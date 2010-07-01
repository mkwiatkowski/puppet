require 'spec_helper'

describe "cities/show.html.haml" do
  before do
    view.stub!(:city_population_summary)
    view.stub!(:city_space_summary)
  end

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

  it "should show city buildings" do
    city = Factory.stub(:city)
    city.should_receive(:buildings).
      and_return([Factory.stub(:building, :name => "HOUSE")])
    assign(:city, city)
    render
    rendered.should contain("HOUSE")
  end
end
