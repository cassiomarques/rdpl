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
end
