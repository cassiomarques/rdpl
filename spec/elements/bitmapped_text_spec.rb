require 'spec_helper'

describe Datamax::BitmappedText do

  it_should_behave_like "element"

  describe "#to_s" do
    it "should return a string represention of the text element" do
      text = Datamax::BitmappedText.new(
        :font_id           => 2,
        :width_multiplier  => 2,
        :height_multiplier => 3,
        :row_position      => 20,
        :column_position   => 30,
        :data              => 'HEY LOOK AT ME'
      )
      text.to_s.should == '122300000200030HEY LOOK AT ME'
    end
  end
end
