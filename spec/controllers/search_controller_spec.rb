require 'spec_helper'

describe SearchController do

  describe "GET 'khan'" do
    it "returns http success" do
      get 'khan'
      response.should be_success
    end
  end

  describe "GET 'youtube'" do
    it "returns http success" do
      get 'youtube'
      response.should be_success
    end
  end

  describe "GET 'educreations'" do
    it "returns http success" do
      get 'educreations'
      response.should be_success
    end
  end

end
