require 'spec_helper'

describe Rdpl::Job do
  def new_job(options = {})
    Rdpl::Job.new({:printer => 'foobar'}.merge(options))
  end

  subject { new_job }

  its(:state) { should == :open }

  describe "sensor" do
    it "returns the current sensor" do
      new_job(:sensor => Rdpl::Sensor::REFLEXIVE).sensor.should == Rdpl::Sensor::REFLEXIVE
    end
  end

  it "uses the edge sensor by default" do
    new_job.dump[0..1].should == Rdpl::STX + Rdpl::Sensor::EDGE
  end

  describe "#measurement" do
    it "returns the current job measurement mode" do
      job = new_job :measurement => :metric
      job.measurement.should == :metric
    end

    it "returns :inches by default" do
      new_job.measurement.should == :inches
    end

    it "do not accepts values different from inches or metric" do
      lambda do
        new_job(:measurement => :foo)
      end.should raise_error(ArgumentError)      
    end
  end

  describe "#in?" do
    it "returns true if the current measurement mode is :inches" do
      new_job.should be_in
    end

    it "returns false if the current measurement mode is not :inches" do
      new_job(:measurement => :metric).should_not be_in
    end
  end

  describe "#mm?" do
    it "returns true if the current measurement mode is :metric" do
      new_job(:measurement => :metric).should be_mm
    end

    it "returns false if the current measurement mode is not :metric" do
      new_job.should_not be_mm
    end
  end

  it "has a list of labels" do
    new_job.labels.should be_instance_of(Array)
  end

  it "requires a CUPS printer name" do
    lambda do
      Rdpl::Job.new
    end.should raise_error(Rdpl::MissingPrinterNameError)    
  end

  describe "#<<" do
    it "adds a new label to the job" do
      job = new_job
      label = Rdpl::Label.new
      expect {
        job << label
      }.to change { job.labels.size }.by(1)
    end

    it "sets itself as the label's job" do
      job = Rdpl::Job.new :printer => 'foobar'
      label = Rdpl::Label.new
      expect {
        job << label
      }.to change { label.instance_variable_get :@job }.from(nil).to(job)
    end
  end

  it "allows iteration through the labels" do
    job = new_job
    job << (label1 = Rdpl::Label.new)
    job << (label2 = Rdpl::Label.new)
    job.map.should == [label1, label2]
  end

  describe "#dump" do
    it "returns the job's contents" do
      job = new_job
      label1 = Rdpl::Label.new
      label1 << 'label1'
      label1.end!
      job << label1
      label2 = Rdpl::Label.new
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
      job.dump[-4..-3].should == Rdpl::STX + Rdpl::FEED
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
