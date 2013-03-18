require "spec_helper"

describe WishesController do
  describe "routing" do

    it "routes to #index" do
      get("/wishes").should route_to("wishes#index")
    end

    it "routes to #new" do
      get("/wishes/new").should route_to("wishes#new")
    end

    it "routes to #show" do
      get("/wishes/1").should route_to("wishes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wishes/1/edit").should route_to("wishes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wishes").should route_to("wishes#create")
    end

    it "routes to #update" do
      put("/wishes/1").should route_to("wishes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wishes/1").should route_to("wishes#destroy", :id => "1")
    end

  end
end
