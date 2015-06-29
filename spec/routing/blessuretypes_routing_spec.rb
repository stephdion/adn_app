require "spec_helper"

describe BlessuretypesController do
  describe "routing" do

    it "routes to #index" do
      get("/blessuretypes").should route_to("blessuretypes#index")
    end

    it "routes to #new" do
      get("/blessuretypes/new").should route_to("blessuretypes#new")
    end

    it "routes to #show" do
      get("/blessuretypes/1").should route_to("blessuretypes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/blessuretypes/1/edit").should route_to("blessuretypes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/blessuretypes").should route_to("blessuretypes#create")
    end

    it "routes to #update" do
      put("/blessuretypes/1").should route_to("blessuretypes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/blessuretypes/1").should route_to("blessuretypes#destroy", :id => "1")
    end

  end
end
