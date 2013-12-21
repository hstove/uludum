require 'spec_helper'

describe "updates/index" do
  before(:each) do
    assign(:updates, [
      stub_model(Update,
        :updateable_type => "Updateable Type",
        :updateable_id => 1,
        :title => "Title",
        :body => "MyText"
      ),
      stub_model(Update,
        :updateable_type => "Updateable Type",
        :updateable_id => 1,
        :title => "Title",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of updates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Updateable Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
