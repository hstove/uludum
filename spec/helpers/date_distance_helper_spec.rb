require 'spec_helper'
describe DateDistanceHelper do
  describe "#time_ago_abbr" do
    it "should abbreviation properly" do
      expect(time_ago_abbr(7.minutes.ago)).to eql("7min")
      expect(time_ago_abbr(1.minute.ago)).to eql("1min")
      expect(time_ago_abbr(20.seconds.ago)).to eql("20s")
      expect(time_ago_abbr(1.second.ago)).to eql("1s")
      expect(time_ago_abbr(20.hours.ago)).to eql("20h")
      expect(time_ago_abbr(1.hour.ago)).to eql("1h")
      expect(time_ago_abbr(20.years.ago)).to eql("20y")
      expect(time_ago_abbr(1.year.ago)).to eql("1y")
      expect(time_ago_abbr(4.weeks.ago)).to eql("28d")
      expect(time_ago_abbr(1.week.ago)).to eql("7d")
      expect(time_ago_abbr(20.days.ago)).to eql("20d")
      expect(time_ago_abbr(1.day.ago)).to eql("1d")
      expect(time_ago_abbr(10.months.ago)).to eql("10m")
      expect(time_ago_abbr(1.month.ago)).to eql("1m")
    end
  end
end
