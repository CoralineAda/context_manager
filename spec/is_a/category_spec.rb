require 'spec_helper'

describe "IsA::Category" do

  before do
    @cat = IsA::Category.create(name: "cat")
    @animal = IsA::Category.create(name: "animal")
    @fur = IsA::Category.create(name: "fur")
    @fangs = IsA::Category.create(name: "fangs")
  end

  describe ".characteristics_tree" do

    it "does stuff" do
      expect(@animal.name).to eq("animal")
    end

  end

end