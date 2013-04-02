module StringUtils
  refine String do
    def is_numeric?
      return true if self =~ /^\d+$/
      true if Float(self) rescue false
    end
  end
end