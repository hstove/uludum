require 'spec_helper'

describe StringUtils do
  if respond_to? :using
    using StringUtils

    it "knows what is numeric" do
      n?(1.25).should == true
      n?(1).should == true
      n?('1.5e4').should == true

      n?('helo').should == false
      n?('1a').should == false
    end

    def n?(input)
      input.to_s.is_numeric?
    end
  end
end