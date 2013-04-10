class String
  alias_method :html_safe_original, :html_safe

  def html_safe
    gsub("\r\n","<br/>").html_safe_original
  end

  def is_numeric?
    return true if self =~ /^\d+$/
    true if Float(self) rescue false
  end

  def slugify
    return self.downcase.gsub(/'/, '').gsub(/[^a-z0-9]+/, '-') do |slug|
      slug.chop! if slug.last == '-'
    end
  end

end

class Float
  def decimals
    self.to_s.split('.').last.size
  end
end
