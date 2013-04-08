require 'spec_helper'

describe "discussions/show" do
  before(:each) do
    @discussion = assign(:discussion, stub_model(Discussion,
      :course_id => 1,
      :user_id => 2,
      :title => "Title",
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
