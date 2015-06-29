require "spec_helper"

describe BodysidesController do
  describe "routing" do

    it "routes to #index" do
      get("/bodysides").should route_to("bodysides#index")
    end

    it "routes to #new" do
      get("/bodysides/new").should route_to("bodysides#new")
    end

    it "routes to #show" do
      get("/bodysides/1").should route_to("bodysides#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bodysides/1/edit").should route_to("bodysides#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bodysides").should route_to("bodysides#create")
    end

    it "routes to #update" do
      put("/bodysides/1").should route_to("bodysides#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bodysides/1").should route_to("bodysides#destroy", :id => "1")
    end

  end
end
