require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Datamax do
  describe "::STX" do
    it "should have the 2 ASCII value" do
      Datamax::STX.should == 2.chr
    end
  end

  describe "::CR" do
    it "should have the 13 ASCII value" do
      Datamax::CR.should == 13.chr
    end
  end

  describe '::LF' do
    it "should have the 10 ASCII value" do
      Datamax::LF.should == 10.chr
    end
  end

  describe "::FEED" do
    it "should have the 'F' caracter" do
      Datamax::FEED.should == 'F'
    end
  end

  describe "::NEW_LILE" do
    it "should be equal to CR and LF concatenated" do
      Datamax::NEW_LINE.should == Datamax::CR + Datamax::LF
    end
  end
end
