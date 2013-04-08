require 'spec_helper'

describe "discussions/index" do
  before(:each) do
    assign(:discussions, [
      stub_model(Discussion,
        :course_id => 1,
        :user_id => 2,
        :title => "Title",
        :body => "MyText"
      ),
      stub_model(Discussion,
        :course_id => 1,
        :user_id => 2,
        :title => "Title",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of discussions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
