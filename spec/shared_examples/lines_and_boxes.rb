shared_examples_for 'lines and boxes' do
  describe "#vertical_width=" do
    it "defines the line's vertical width" do
      element.vertical_width = 10
      element.instance_variable_get(:@vertical_width).should == 10
    end
  end

  describe "#vertical_width" do
    it "returns the line's vertical width" do
      element.vertical_width = 10
      element.vertical_width.should == 10
    end

    it "returns 0 by default" do
      element.vertical_width.should be_zero
    end
  end

  describe "#horizontal_width=" do
    it "defines the line's horizontal width" do
      element.horizontal_width = 15
      element.instance_variable_get(:@horizontal_width).should == 15
    end
  end

  describe "#horizontal_width" do
    it "returns the line's horizontal width" do
      element.horizontal_width = 15
      element.horizontal_width.should == 15
    end

    it "returns 0 by default" do
      element.horizontal_width.should be_zero
    end
  end

  describe "#width_multiplier" do
    it "defaults to 1" do
      element.width_multiplier.should == 1
    end
  end

  describe "#height_multiplier" do
    it "defaults to 1" do
      element.height_multiplier.should == 1
    end
  end

  describe "#width_multiplier=" do
    it "should raise FixedValueError when trying to change the value" do
      lambda do
        element.width_multiplier = 2
      end.should raise_error(Datamax::Element::FixedValueError)
    end
  end

  describe "#height_multiplier=" do
    it "should raise FixedValueError when trying to change the value" do
      lambda do
        element.height_multiplier = 2
      end.should raise_error(Datamax::Element::FixedValueError)
    end
  end

  describe "#data=" do
    it "should raise InvalidAssigmentError" do
      lambda do
        element.data = 'foo'
      end.should raise_error(Datamax::Element::InvalidAssigmentError)
    end
  end
end
