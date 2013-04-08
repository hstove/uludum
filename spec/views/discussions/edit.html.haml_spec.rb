require 'spec_helper'

describe "discussions/edit" do
  before(:each) do
    @discussion = assign(:discussion, stub_model(Discussion,
      :course_id => 1,
      :user_id => 1,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit discussion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", discussion_path(@discussion), "post" do
      assert_select "input#discussion_course_id[name=?]", "discussion[course_id]"
      assert_select "input#discussion_user_id[name=?]", "discussion[user_id]"
      assert_select "input#discussion_title[name=?]", "discussion[title]"
      assert_select "textarea#discussion_body[name=?]", "discussion[body]"
    end
  end
end
