require 'spec_helper'

describe PagesController do
  it "takes time", performance: true do
    10.times{ Benchmark.realtime { get :show, template: :about }.should < 0.1 }
  end
end
