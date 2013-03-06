class String
  alias_method :html_safe_original, :html_safe

  def html_safe
    self.gsub("\r\n","<br/>")
    self.html_safe_original
  end
end
