class String
  alias_method :html_safe_original, :html_safe

  def html_safe
    gsub("\r\n","<br/>").html_safe_original
  end

  def is_numeric?
    return true if self =~ /^\d+$/
    true if Float(self) rescue false
  end
end

class Float
  def decimals
    self.to_s.split('.').last.size
  end
end
