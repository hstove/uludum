module DateTimeExt
  def abbreviated
    string = strftime("%b %e")
    if self.year != self.class.now.year
      string += strftime(", %Y")
    end
    string
  end
end

class DateTime
  include DateTimeExt
end
class Time
  include DateTimeExt
end
