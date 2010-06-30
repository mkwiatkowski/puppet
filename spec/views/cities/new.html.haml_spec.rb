require 'spec_helper'

describe "cities/new.html.haml" do
  it "should have a form with a name field" do
    assign(:city, Factory.stub(:city))
    render
    rendered.should have_selector("form > input#city_name")
  end
end
