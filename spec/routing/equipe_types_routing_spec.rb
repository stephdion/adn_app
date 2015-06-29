require "spec_helper"

describe EquipeTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/equipe_types").should route_to("equipe_types#index")
    end

    it "routes to #new" do
      get("/equipe_types/new").should route_to("equipe_types#new")
    end

    it "routes to #show" do
      get("/equipe_types/1").should route_to("equipe_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/equipe_types/1/edit").should route_to("equipe_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/equipe_types").should route_to("equipe_types#create")
    end

    it "routes to #update" do
      put("/equipe_types/1").should route_to("equipe_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/equipe_types/1").should route_to("equipe_types#destroy", :id => "1")
    end

  end
end
