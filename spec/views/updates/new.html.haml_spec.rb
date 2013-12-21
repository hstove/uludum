require 'spec_helper'

describe "updates/new" do
  before(:each) do
    assign(:update, stub_model(Update,
      :updateable_type => "MyString",
      :updateable_id => 1,
      :title => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new update form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", updates_path, "post" do
      assert_select "input#update_updateable_type[name=?]", "update[updateable_type]"
      assert_select "input#update_updateable_id[name=?]", "update[updateable_id]"
      assert_select "input#update_title[name=?]", "update[title]"
      assert_select "textarea#update_body[name=?]", "update[body]"
    end
  end
end
