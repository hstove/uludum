class String
  alias_method :html_safe_original, :html_safe

  def html_safe_sanitized
    sanitized = self.sanitize!
    sanitized = Utensil.render(sanitized)
    sanitized.html_safe_original
  end

  def sanitize!
    options = Sanitize::Config::BASIC
    options[:elements].concat %w[img div label input textarea utensil]
    options[:add_attributes]['a']['target'] = "_blank"
    options[:attributes]['img'] = ['src']
    options[:attributes]['utensil'] = ['data-json']
    Sanitize.clean(self, options)
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
