require 'spec_helper'

describe "wishes/show" do
  before(:each) do
    @wish = assign(:wish, stub_model(Wish))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
