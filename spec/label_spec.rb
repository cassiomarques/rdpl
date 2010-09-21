require 'spec_helper'


describe Rdpl::Label do
  def end_with_new_line
    simple_matcher('creates a new line') { |actual| actual[-2..-1] == CR + LF }
  end

  describe "::DEFAULT_DOT_SIZE" do
    subject { Rdpl::Label::DEFAULT_DOT_SIZE }
    it { should == 11 }
  end

  describe "::DEFAULT_HEAT" do
    subject { Rdpl::Label::DEFAULT_HEAT }
    it { should == 14 }
  end

  its(:state) { should == :open }

  describe "mm?" do
    it "delegates to the printing job" do
      label = Rdpl::Label.new
      label.job = Rdpl::Job.new :printer => 'foobar', :measurement => :metric
      label.should be_mm
    end

    it "returns false if the label has no job" do
      Rdpl::Label.new.should_not be_mm
    end
  end

  describe "#contents" do
    it "is always started with STX L (for Label start), plus the dot size and heating settings" do
      label = Rdpl::Label.new
      expected = Rdpl::STX +
                 Rdpl::Label::START +
                 Rdpl::NEW_LINE +
                 "H#{Rdpl::Label::DEFAULT_HEAT}" +
                 Rdpl::NEW_LINE +
                 "D#{Rdpl::Label::DEFAULT_DOT_SIZE}" +
                 Rdpl::NEW_LINE
      label.dump.should == expected
    end
  end

  describe "#end!" do
    let(:label) { Rdpl::Label.new }

    it "marks the label's end" do
      label.end!
      label[-3..-1].should == 'E' + Rdpl::NEW_LINE
    end

    it "alters the state to :closed" do
      expect {
        label.end!
      }.to change { label.state }.to(:finished)
    end

    it "adds the quantity command if a quantity was specified" do
      label = Rdpl::Label.new
      label.quantity = 5
      label.end!
      label.dump[-10..-6].should == 'Q0005'
    end
  end

  it "raises Rdpl::EndedElementError if it's ended andwe try to add new content" do
    label = Rdpl::Label.new
    label.end!
    lambda do
      label << 'some content'
    end.should raise_error(Rdpl::EndedElementError)
  end

  describe "#command" do
    let(:label) { Rdpl::Label.new }
    before(:each) { label.command 'FOO' }

    it { end_with_new_line }

    it "records the command in the label's contents" do
      expected = Rdpl::STX + 'FOO'
      label.dump.should include(expected)
    end

    it "ends with CR/LF" do
      expected = Rdpl::CR + Rdpl::LF
      label[-2..-1].should == expected
    end
  end

  describe "#<<" do
    let(:label) { Rdpl::Label.new }

    before(:each) { label << 'BAR' }

    it { end_with_new_line }

    it "puts the text inside the label" do
      label.dump.should include('BAR')
    end

    it "allows inserting non-string elements" do
      label << Rdpl::Barcode.new(:data => 'BARCODE')
      label.dump.should include('BARCODE')
    end
  end

  describe "#dot_size" do
    it "returns the current dot size" do
      Rdpl::Label.new(:dot_size => 20).dot_size.should == 20
    end

    it "returns Label::DEFAULT_DOT_SIZE by default" do
      Rdpl::Label.new.dot_size.should == Rdpl::Label::DEFAULT_DOT_SIZE
    end
  end

  describe "#heat" do
    it "returns the current heat setting" do
      Rdpl::Label.new(:heat => 25).heat.should == 25
    end

    it "returns Label::DEFAULT_HEAT by default" do
      Rdpl::Label.new.heat.should == Rdpl::Label::DEFAULT_HEAT
    end
  end

  describe "#start_of_print" do
    it "returns nil if start_of_print was not specified" do
      Rdpl::Label.new.start_of_print.should be_nil
    end

    describe "when the measurenemt mode is inches" do
      it "returns the configured start of print" do
        Rdpl::Label.new(:start_of_print => '0123').start_of_print.should == 1.23
      end
    end

    describe "when the measurement mode is metric" do
      it "returns the configured start of print" do
        label = Rdpl::Label.new(:start_of_print => '0123')
        label.job = Rdpl::Job.new :printer => 'foo', :measurement => :metric
        label.start_of_print.should == 12.3
      end
    end
  end

  describe "#add_line" do
    it "should add a line element to the label's contents" do
      label = Rdpl::Label.new
      label.add_line do |line|
        line.horizontal_width = 12.2
        line.vertical_width   = 14.3
        line.row_position     = 23.4
        line.column_position  = 24.5
      end
      label.dump.should include("1X1100002340245l01220143#{Rdpl::NEW_LINE}")
    end
  end

  describe "#add_box" do
    it "should add a box element to the label's contents" do
      label = Rdpl::Label.new
      label.add_box do |box|
        box.horizontal_width         = 12.2
        box.vertical_width           = 14.3
        box.row_position             = 23.4
        box.column_position          = 24.5
        box.bottom_and_top_thickness = 34.6
        box.sides_thickness          = 45.6
      end
      label.dump.should include("1X1100002340245b0122014303460456#{Rdpl::NEW_LINE}")
    end
  end

  describe "#add_barcode" do
    it "should add a barcode element to the label's contents" do
      label = Rdpl::Label.new
      label.add_barcode do |barcode|
        barcode.rotation              = 4
        barcode.font_id               = 'e'
        barcode.data                  = 'SOME DATA 12345'
        barcode.height                = 123
        barcode.wide_bar_multiplier   = 3
        barcode.narrow_bar_multiplier = 4
        barcode.row_position          = 123
        barcode.column_position       = 234
      end
      label.dump.should include('4e3412301230234SOME DATA 12345')
    end
  end

  describe "#add_bitmapped_text" do
    it "should add a bitmapped text element to the labe's contents" do
      label = Rdpl::Label.new
      label.add_bitmapped_text do |text|
        text.font_id           = 2
        text.width_multiplier  = 2
        text.height_multiplier = 3
        text.row_position      = 20
        text.column_position   = 30
        text.data              = 'HEY LOOK AT ME'
      end
      label.dump.should include('122300000200030HEY LOOK AT ME')
    end
  end
end
