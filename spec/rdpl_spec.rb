require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rdpl do
  describe "::STX" do
    it "should have the 2 ASCII value" do
      Rdpl::STX.should == 2.chr
    end
  end

  describe "::CR" do
    it "should have the 13 ASCII value" do
      Rdpl::CR.should == 13.chr
    end
  end

  describe '::LF' do
    it "should have the 10 ASCII value" do
      Rdpl::LF.should == 10.chr
    end
  end

  describe "::FEED" do
    it "should have the 'F' caracter" do
      Rdpl::FEED.should == 'F'
    end
  end

  describe "::NEW_LILE" do
    it "should be equal to CR and LF concatenated" do
      Rdpl::NEW_LINE.should == Rdpl::CR + Rdpl::LF
    end
  end
end
