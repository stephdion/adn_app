require "spec_helper"

describe BodypartsController do
  describe "routing" do

    it "routes to #index" do
      get("/bodyparts").should route_to("bodyparts#index")
    end

    it "routes to #new" do
      get("/bodyparts/new").should route_to("bodyparts#new")
    end

    it "routes to #show" do
      get("/bodyparts/1").should route_to("bodyparts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bodyparts/1/edit").should route_to("bodyparts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bodyparts").should route_to("bodyparts#create")
    end

    it "routes to #update" do
      put("/bodyparts/1").should route_to("bodyparts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bodyparts/1").should route_to("bodyparts#destroy", :id => "1")
    end

  end
end
