require 'spec_helper'

describe Datamax::Barcode do
  let(:barcode) { Datamax::Barcode.new }

  describe "::CODE_128" do
    it "equals 'E'" do
      Datamax::Barcode::CODE_128.should == 'E'
    end
  end

  describe "#height=" do
    it "defines the barcode height" do
      barcode.height = 100
      barcode.instance_variable_get(:@height).should == 100
    end

    it "raises InvalidBarcodeHeightError if the height is less than 0" do
      lambda do
        barcode.height = -1
      end.should raise_error(Datamax::Element::InvalidBarcodeHeightError)
    end

    it "raises InvalidBarcodeHeightError if the height is above 999" do
      lambda do
        barcode.height = 1000
      end.should raise_error(Datamax::Element::InvalidBarcodeHeightError)
    end
  end

  describe "#height" do
    let(:barcode) { Datamax::Barcode.new }

    it "returns the barcode height" do
      barcode.height = 100
      barcode.height.should == 100
    end

    it "returns 25 by default" do
      barcode.height.should == 25
    end
  end

  describe "#to_s" do
    it "returns the barcode's string representation" do
      barcode = Datamax::Barcode.new(
        :rotation              => 4,
        :font_id               => 'e',
        :data                  => 'SOME DATA 12345',
        :height                => 123,
        :wide_bar_multiplier   => 3,
        :narrow_bar_multiplier => 4,
        :row_position          => 123,
        :column_position       => 234
      )
      barcode.to_s.should == '4e3412301230234SOME DATA 12345'
    end
  end
end
