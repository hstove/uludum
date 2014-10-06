class String
  alias_method :html_safe_original, :html_safe

  def html_safe_sanitized
    sanitized = self.sanitize!
    sanitized = Utensil.render(sanitized)
    sanitized.html_safe_original
  end

  def sanitize!
    options = Sanitize::Config::BASIC
    options[:elements].concat %w[img div utensil]
    options[:elements].concat %w[h1 h2 h3 h4 h5 h6]
    options[:add_attributes]['a']['target'] = "_blank"
    options[:attributes]['img'] = ['src']
    options[:attributes]['utensil'] = ['data-json']
    options[:attributes]['code'] = ['class']
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
