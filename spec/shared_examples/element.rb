shared_examples_for "element" do
  let(:element) { described_class.new }

  describe "#rotation=" do
    it "defines the element's rotation" do
      element.rotation = 1
      element.instance_variable_get(:@rotation).should == 1
    end

    it "raises InvalidRotationError if the value is below the range limit" do
      lambda do
        element.rotation = element.send(:valid_rotation_range).to_a[0] - 1
      end.should raise_error(Datamax::Element::InvalidRotationError)
    end

    it "raises InvalidRotationError if the value is above the range limit" do
      lambda do
        element.rotation = element.send(:valid_rotation_range).to_a[-1] + 1
      end.should raise_error(Datamax::Element::InvalidRotationError)
    end
  end

  describe "#rotation" do
    it "returns the element's rotation" do
      array = element.send(:valid_rotation_range).entries
      rotation = array[rand(array.size)]
      element.rotation = rotation
      element.rotation.should == rotation
    end

    it "returns a default value when empty" do
      default_rotation = element.send :default_rotation
      element.rotation.should == default_rotation
    end
  end

  describe "#font_id=" do
    it "defines the element's font id" do
      array = element.send(:valid_font_id_ranges).first.entries
      font_id = array[rand(array.size)]
      element.font_id = font_id
      element.instance_variable_get(:@font_id).should == font_id
    end

    it "raises InvalidFontIdError if the font_id is below the range limit" do
      lambda do
        element.font_id = element.send(:valid_font_id_ranges).first.to_a[0] - 1
      end.should raise_error(Datamax::Element::InvalidFontIdError)
    end

    it "raises InvalidFontIdError if the font_id is above 9" do
      lambda do
        element.font_id = element.send(:valid_font_id_ranges).first.to_a[-1] + 1
      end.should raise_error(Datamax::Element::InvalidFontIdError)
    end
  end

  describe "#font_id" do
    it "returns the element font_id" do
      array = element.send(:valid_font_id_ranges).first.entries
      font_id = array[rand(array.size)]
      element.font_id = font_id
      element.font_id.should == font_id
    end
  end

  describe "#width_multiplier=" do
    it "defines the element's width multiplier" do
      element.width_multiplier = 2
      element.instance_variable_get(:@width_multiplier).should == 2
    end

    it "raises InvalidWidthMultiplierError if the multiplier is less than 1 (base 25)" do
      lambda do
        element.width_multiplier = 0
      end.should raise_error(Datamax::Element::InvalidWidthMultiplierError)
    end

    it "raises InvalidWidthMultiplierError if the multiplier is more than O (base 25)" do
      lambda do
        element.width_multiplier = 'P'           
      end.should raise_error(Datamax::Element::InvalidWidthMultiplierError)
    end

    it "raises InvalidWidthMultiplierError if the multiplier is not in base 25" do
      lambda do
        element.width_multiplier = 10
      end.should raise_error(Datamax::Element::InvalidWidthMultiplierError)
    end
  end

  describe "#width_multiplier" do
    it "returns the defined width multiplier" do
      element.width_multiplier = 9
      element.width_multiplier.should == 9
    end

    it "returns 1 by default" do
      element.width_multiplier.should == 1
    end
  end

  describe "height_multiplier=" do
    it "defines the element's height multiplier" do
      element.height_multiplier = 2
      element.instance_variable_get(:@height_multiplier).should == 2
    end

    it "raises InvalidHeightMultiplierError if the multiplier is less than 1 (base 25)" do
      lambda do
        element.height_multiplier = 0
      end.should raise_error(Datamax::Element::InvalidHeightMultiplierError)
    end

    it "raises InvalidHeightMultiplierError if the multiplier is more than O (base 25)" do
      lambda do
        element.height_multiplier = 'P'           
      end.should raise_error(Datamax::Element::InvalidHeightMultiplierError)
    end

    it "raises InvalidHeightMultiplierError if the multiplier is not in base 25" do
      lambda do
        element.height_multiplier = 10
      end.should raise_error(Datamax::Element::InvalidHeightMultiplierError)
    end
  end

  describe "#height_multiplier" do
    it "returns the defined height multiplier" do
      element.height_multiplier = 9
      element.height_multiplier.should == 9
    end

    it "returns 1 by default" do
      element.height_multiplier.should == 1
    end
  end

  describe "#row_position=" do
    it "defines how far above the 'home position' the element is" do
      element.row_position = 10
      element.instance_variable_get(:@row_position).should == 10
    end
  end

  describe "#row_position" do
    it "returns the element's row position (y)" do
      element.row_position = 10
      element.row_position.should == 10
    end

    it "returns 0 (zero) by default" do
      element.row_position.should be_zero
    end
  end

  describe "#column_position=" do
    it "defines how far to the right from the 'home position' the element is" do
      element.column_position = 10
      element.instance_variable_get(:@column_position).should == 10
    end
  end

  describe "#column_position" do
    it "returns the element's column position (x)" do
      element.column_position = 10
      element.column_position.should == 10
    end

    it "returns 0 (zero) by default" do
      element.column_position.should be_zero
    end
  end

  describe "#data=" do
    it "defines the element's data" do
      element.data = 'foobar'
      element.instance_variable_get(:@data).should == 'foobar'
    end
  end

  describe "#data" do
    it "returns the element's data" do
      element.data = 'foobar'
      element.data.should == 'foobar'
    end

    it "returns an empty string by default" do
      element.data.should == ''
    end
  end
end
