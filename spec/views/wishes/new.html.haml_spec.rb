require 'spec_helper'

describe "wishes/new" do
  before(:each) do
    assign(:wish, stub_model(Wish).as_new_record)
  end

  it "renders new wish form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", wishes_path, "post" do
    end
  end
end
