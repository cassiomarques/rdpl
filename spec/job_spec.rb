require 'spec_helper'

describe Datamax::Job do
  def new_job(options = {})
    Datamax::Job.new({:printer => 'foobar'}.merge(options))
  end

  subject { new_job }

  its(:state) { should == :open }

  describe "sensor" do
    it "returns the current sensor" do
      new_job(:sensor => Datamax::Sensor::REFLEXIVE).sensor.should == Datamax::Sensor::REFLEXIVE
    end
  end

  it "uses the edge sensor by default" do
    new_job.dump[0..1].should == Datamax::STX + Datamax::Sensor::EDGE
  end

  it "has a list of labels" do
    new_job.labels.should be_instance_of(Array)
  end

  it "requires a CUPS printer name" do
    lambda do
      Datamax::Job.new
    end.should raise_error(Datamax::MissingPrinterNameError)    
  end

  describe "#<<" do
    it "adds a new label to the job" do
      job = new_job
      label = Datamax::Label.new
      expect {
        job << label
      }.to change { job.labels.size }.by(1)
    end
  end

  it "allows iteration through the labels" do
    job = new_job
    job << (label1 = Datamax::Label.new)
    job << (label2 = Datamax::Label.new)
    job.map.should == [label1, label2]
  end

  describe "#dump" do
    it "returns the job's contents" do
      job = new_job
      label1 = Datamax::Label.new
      label1 << 'label1'
      label1.end!
      job << label1
      label2 = Datamax::Label.new
      label2 << 'label2'
      label2.end!
      job << label2
      expected = "\002e\r\n\002L\r\nH14\r\nD11\r\nlabel1\r\nE\r\n\002F\r\n\002L\r\nH14\r\nD11\r\nlabel2\r\nE\r\n\002F\r\n"
      job.dump.should == expected
    end
  end

  describe "#feed" do
    it "adds the form feed command to the job" do
      job = new_job
      job.feed
      job.dump[-4..-3].should == Datamax::STX + Datamax::FEED
    end
  end
  describe "#print" do
    let(:temp_file) { "" }

    before :each do
      temp_file.stub!(:close).and_return(true)
      temp_file.stub!(:path).and_return("/tmp/datamax_label123")
      Tempfile.stub!(:new).and_return(temp_file)
    end

    it "creates a temporary file with its contents" do
      Tempfile.should_receive(:new).with('datamax_label').and_return(temp_file)
      new_job.print
    end

    it "sends the job to the printer" do
      Kernel.should_receive(:system).with('lpr -P foobar /tmp/datamax_label123')
      new_job.print
    end
  end
end
