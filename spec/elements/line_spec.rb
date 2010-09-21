require 'spec_helper'

describe Rdpl::Line do
  let(:element) { Rdpl::Line.new }

  it_should_behave_like 'lines and boxes'

  describe "#to_s" do
    it "should return a string represention of the graphic element" do
      line = Rdpl::Line.new(
        :horizontal_width => 12.2,
        :vertical_width   => 14.3,
        :row_position     => 23.4,
        :column_position  => 24.5
      )
      line.to_s.should == "1X1100002340245l01220143"
    end
  end
end
