require 'spec_helper'

describe "updates/show" do
  before(:each) do
    @update = assign(:update, stub_model(Update,
      :updateable_type => "Updateable Type",
      :updateable_id => 1,
      :title => "Title",
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Updateable Type/)
    rendered.should match(/1/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
