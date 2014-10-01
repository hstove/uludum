module DateDistanceHelper
  def time_ago_abbr date
    distance = time_ago_in_words(date)
    if (seconds = (Time.now - date).to_i) < 60
      distance = "#{seconds} seconds"
    end
    distance.gsub! "about ", ""
    time_ago_abbreviations.each do |abbr, str|
      distance.gsub!(/ #{abbr}s?/, str)
    end
    distance
  end

  def time_ago_abbreviations
    @time_ago_abbreviations ||= {
      month: "m",
      day: "d",
      minute: "min",
      second: "s",
      week: "w",
      year: "y",
      hour: "h",
    }
  end
end
