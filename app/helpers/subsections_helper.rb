module SubsectionsHelper
  def sidebar_subsections subsection
    html = ""
    @subsection.section.subsections.each do |s|
      title = s.title
      title = icon(:ok) + " " + title if complete?(s)
      html << "<li>"+link_to(title, s, class: "#{s.id == @subsection.id ? 'light-purple' : 'white'}") + "</li>"
    end
    html.html_safe
  end

  def percent_complete_subsection subsection
    return "0%" unless logged_in?
    subsection.percent_complete(current_user).to_s + "%"
  end
end
