class HideKhanCourses < ActiveRecord::Migration
  def up
    Course.where(teacher_id: 1).update_all hidden: true
  end

  def down
    Course.where(teacher_id: 1).where("questions_count > 0")
      .update_all(hidden: false)
  end

end
