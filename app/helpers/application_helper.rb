module ApplicationHelper
  def icon style, white=false
    i = "<i class=\"icon icon-#{style.to_s}"
    i << " icon-white" if white
    i << "\"></i>"
    i.html_safe
  end
end
