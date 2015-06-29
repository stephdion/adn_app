require "spec_helper"

describe Scat2sController do
  describe "routing" do

    it "routes to #index" do
      get("/scat2s").should route_to("scat2s#index")
    end

    it "routes to #new" do
      get("/scat2s/new").should route_to("scat2s#new")
    end

    it "routes to #show" do
      get("/scat2s/1").should route_to("scat2s#show", :id => "1")
    end

    it "routes to #edit" do
      get("/scat2s/1/edit").should route_to("scat2s#edit", :id => "1")
    end

    it "routes to #create" do
      post("/scat2s").should route_to("scat2s#create")
    end

    it "routes to #update" do
      put("/scat2s/1").should route_to("scat2s#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/scat2s/1").should route_to("scat2s#destroy", :id => "1")
    end

  end
end
