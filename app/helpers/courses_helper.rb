module CoursesHelper
  def categories_options_tag
    cats = []
    Course.categories.each do |c|
      cats << [c.category, c.category]
    end
    options_for_select(cats)
  end
end
