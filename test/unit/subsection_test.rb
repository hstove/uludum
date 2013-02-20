require 'test_helper'

class SubsectionTest < ActiveSupport::TestCase
  test "sets course correctly" do
    @section = create :section
    @s = Subsection.new title: 'ya', body: 'woo', section_id: @section.id
    assert @s.save, "subsection should save"
    assert_equal @s.course_id, @section.course_id, "course_id should be set"
  end

end
