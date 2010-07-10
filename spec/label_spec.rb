require 'spec_helper'


describe Datamax::Label do
  def end_with_new_line
    simple_matcher('creates a new line') { |actual| actual[-2..-1] == CR + LF }
  end

  describe "::DEFAULT_DOT_SIZE" do
    subject { Datamax::Label::DEFAULT_DOT_SIZE }
    it { should == 11 }
  end

  describe "::DEFAULT_HEAT" do
    subject { Datamax::Label::DEFAULT_HEAT }
    it { should == 14 }
  end

  its(:state) { should == :open }

  describe "mm?" do
    it "delegates to the printing job" do
      label = Datamax::Label.new
      label.job = Datamax::Job.new :printer => 'foobar', :measurement => :metric
      label.should be_mm
    end

    it "returns false if the label has no job" do
      Datamax::Label.new.should_not be_mm
    end
  end

  describe "#contents" do
    it "is always started with STX L (for Label start), plus the dot size and heating settings" do
      label = Datamax::Label.new
      expected = Datamax::STX + 
                 Datamax::Label::START + 
                 Datamax::NEW_LINE + 
                 "H#{Datamax::Label::DEFAULT_HEAT}" +
                 Datamax::NEW_LINE + 
                 "D#{Datamax::Label::DEFAULT_DOT_SIZE}" + 
                 Datamax::NEW_LINE
      label.dump.should == expected
    end
  end

  describe "#end!" do
    let(:label) { Datamax::Label.new }

    it "marks the label's end" do
      label.end!
      label[-3..-1].should == 'E' + Datamax::NEW_LINE
    end

    it "alters the state to :closed" do
      expect {
        label.end!
      }.to change { label.state }.to(:finished)
    end
  end

  it "raises Datamax::EndedElementError if it's ended andwe try to add new content" do
    label = Datamax::Label.new
    label.end!
    lambda do
      label << 'some content'
    end.should raise_error(Datamax::EndedElementError)
    
  end

  describe "#command" do
    let(:label) { Datamax::Label.new }
    before(:each) { label.command 'FOO' }

    it { end_with_new_line }

    it "records the command in the label's contents" do
      expected = Datamax::STX + 'FOO'
      label.dump.should include(expected)
    end

    it "ends with CR/LF" do
      expected = Datamax::CR + Datamax::LF
      label[-2..-1].should == expected
    end
  end

  describe "#<<" do
    let(:label) { Datamax::Label.new }

    before(:each) { label << 'BAR' }

    it { end_with_new_line }

    it "puts the text inside the label" do
      label.dump.should include('BAR')
    end
  end

  describe "#start_of_print" do
    
  end

  describe "#dot_size" do
    it "returns the current dot size" do
      Datamax::Label.new(:dot_size => 20).dot_size.should == 20
    end

    it "returns Label::DEFAULT_DOT_SIZE by default" do
      Datamax::Label.new.dot_size.should == Datamax::Label::DEFAULT_DOT_SIZE
    end
  end

  describe "#heat" do
    it "returns the current heat setting" do
      Datamax::Label.new(:heat => 25).heat.should == 25
    end

    it "returns Label::DEFAULT_HEAT by default" do
      Datamax::Label.new.heat.should == Datamax::Label::DEFAULT_HEAT
    end
  end

  describe "#start_of_print" do
    it "returns nil if start_of_print was not specified" do
      Datamax::Label.new.start_of_print.should be_nil
    end

    describe "when the measurenemt mode is inches" do
      it "returns the configured start of print" do
        Datamax::Label.new(:start_of_print => '0123').start_of_print.should == 1.23
      end
    end

    describe "when the measurement mode is metric" do
      it "returns the configured start of print" do
        label = Datamax::Label.new(:start_of_print => '0123')
        label.job = Datamax::Job.new :printer => 'foo', :measurement => :metric
        label.start_of_print.should == 12.3
      end
    end
  end
end
