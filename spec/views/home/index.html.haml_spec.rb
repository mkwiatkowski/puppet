require 'spec_helper'

describe "home/index.html.haml" do
  it "should welcome the player" do
    render
    rendered.should have_selector("h1", :content => "Welcome to puppet!")
  end
end
