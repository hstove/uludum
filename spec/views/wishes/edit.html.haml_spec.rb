require 'spec_helper'

describe "wishes/edit" do
  before(:each) do
    @wish = assign(:wish, stub_model(Wish))
  end

  it "renders the edit wish form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", wish_path(@wish), "post" do
    end
  end
end
