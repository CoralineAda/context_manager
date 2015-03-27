require 'rails_spec'

describe "IsA::Parser" do

  before do
    @cat = IsA::Category.create(name: "cat")
    @animal = IsA::Category.create(name: "animal")
  end

  context "context" do

    describe "detects a characteristic question" do
      it "like 'Is the cat black?'" do
        parser = IsA::Parser.new("Is the cat black?")
        expect(parser.send(:is_characteristic_question?)).to be_truthy
      end
    end

    describe "detects a characteristic definition" do
      it "like 'The cat is black.'" do
        parser = IsA::Parser.new("The cat is black.")
        expect(parser.send(:is_characteristic_definition?)).to be_truthy
      end
    end

    describe "detects a category undefinition" do
      it "like 'The cat isn't a bird.'" do
        parser = IsA::Parser.new("The cat isn't a bird.")
        expect(parser.send(:is_category_undefinition?)).to be_truthy
      end
    end

    describe "detects a category question" do
      it "like 'Is the cat a bird?'" do
        parser = IsA::Parser.new("Is the cat a bird?")
        expect(parser.send(:is_category_question?)).to be_truthy
      end
      it "like 'Is a cat a lion?'" do
        parser = IsA::Parser.new("Is a cat a lion?")
        expect(parser.send(:is_category_question?)).to be_truthy
      end
    end

    describe "detects a component question" do
      it "like 'Does a cat have legs?" do
        parser = IsA::Parser.new("Does a cat have legs?")
        expect(parser.send(:is_component_question?)).to be_truthy
      end
    end

    describe "detects a component definition" do
      it "like 'A cat has fur." do
        parser = IsA::Parser.new("A cat has fur.")
        expect(parser.send(:is_component_definition?)).to be_truthy
      end

    end

  end

end
