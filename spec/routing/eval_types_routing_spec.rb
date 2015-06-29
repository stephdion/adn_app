require "spec_helper"

describe EvalTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/eval_types").should route_to("eval_types#index")
    end

    it "routes to #new" do
      get("/eval_types/new").should route_to("eval_types#new")
    end

    it "routes to #show" do
      get("/eval_types/1").should route_to("eval_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/eval_types/1/edit").should route_to("eval_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/eval_types").should route_to("eval_types#create")
    end

    it "routes to #update" do
      put("/eval_types/1").should route_to("eval_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/eval_types/1").should route_to("eval_types#destroy", :id => "1")
    end

  end
end
