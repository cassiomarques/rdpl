require 'spec_helper'

describe Datamax::Box do
  let(:element) { Datamax::Box.new }

  it_should_behave_like 'lines and boxes'

  describe "#bottom_and_top_thickness=" do
    it "defines the thickness of bottom and top box edges" do
      element.bottom_and_top_thickness = 23.4
      element.instance_variable_get(:@bottom_and_top_thickness).should == 23.4
    end
  end

  describe "#bottom_and_top_thickness" do
    it "returns the thickness of bottom and top box edges" do
      element.bottom_and_top_thickness = 23.4
      element.bottom_and_top_thickness.should == 23.4
    end

    it "returns 0 by default" do
      element.bottom_and_top_thickness.should be_zero
    end
  end

  describe "#sides_thickness=" do
    it "defines the thickness of the box' sides" do
      element.sides_thickness = 23.5
      element.instance_variable_get(:@sides_thickness).should == 23.5
    end
  end

  describe "#sides_thickness" do
    it "returns the thickness of the box' sides" do
      element.sides_thickness = 23.5
      element.sides_thickness.should == 23.5
    end

    it "returns 0 by default" do
      element.sides_thickness.should be_zero
    end
  end

  describe "#to_s" do
    it "should return a string represention of the graphic element" do
      box = Datamax::Box.new(
        :horizontal_width         => 12.2,
        :vertical_width           => 14.3,
        :row_position             => 23.4,
        :column_position          => 24.5,
        :bottom_and_top_thickness => 34.6,
        :sides_thickness          => 45.6
      )
      box.to_s.should == "1X1100002340245b0122014303460456"
    end
  end
end
