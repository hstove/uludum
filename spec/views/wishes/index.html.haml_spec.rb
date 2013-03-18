require 'spec_helper'

describe "wishes/index" do
  before(:each) do
    assign(:wishes, [
      stub_model(Wish),
      stub_model(Wish)
    ])
  end

  it "renders a list of wishes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
