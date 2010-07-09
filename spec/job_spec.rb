require 'spec_helper'

describe Datamax::Job do
  describe "sensor" do
    it "returns the current sensor" do
      Datamax::Job.new(:sensor => Datamax::Sensor::REFLEXIVE).sensor.should == Datamax::Sensor::REFLEXIVE
    end
  end

  it "uses the edge sensor by default" do
    Datamax::Job.new.contents[0..1].should == Datamax::STX + Datamax::Sensor::EDGE
  end

  it "has a list of labels" do
    Datamax::Job.new.labels.should be_instance_of(Array)
  end

  describe "#<<" do
    it "adds a new label to the job" do
      job = Datamax::Job.new
      label = Datamax::Label.new
      expect {
        job << label
      }.to change { job.labels.size }.by(1)
    end
  end

  it "allows iteration through the labels" do
    job = Datamax::Job.new
    job << (label1 = Datamax::Label.new)
    job << (label2 = Datamax::Label.new)
    job.map.should == [label1, label2]
  end

  describe "#dump" do
    it "returns the job's contents" do
      job = Datamax::Job.new
      label1 = Datamax::Label.new
      label1 << 'label1'
      label1.end!
      label2 = Datamax::Label.new
      label2 << 'label2'
      label2.end!
    end
  end
end
