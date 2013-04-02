module FloatUtils
  refine Float do
    def decimals
      self.to_s.split('.').last.size
    end
  end
end