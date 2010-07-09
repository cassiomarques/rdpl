require 'tempfile'

module Datamax
  class Job
    attr_reader :labels, :printer, :state
    attr_writer :sensor

    include Commandable
    include Enumerable

    def initialize(options = {})
      initialize_options options
      @contents = ''
      start
      @labels = []
    end

    def each
      @labels.each { |label| yield label }
    end

    def sensor
      @sensor ||= Sensor::EDGE
    end

    def <<(label)
      @labels << label
      @contents << label.dump
      feed
    end
    alias :add_label :<<

    def dump
      @contents.dup
    end

    def feed
      command FEED
    end

    def print
      tempfile = Tempfile.new 'datamax_label'
      tempfile << dump
      tempfile.close
      Kernel.system "lpr -P #{printer} #{tempfile.path}"
    end

    private
    def printer=(printer)
      @printer = printer
    end

    def initialize_options(options)
      options.each_pair { |option, value| self.send("#{option}=", value) }  
      raise MissingPrinterNameError if printer.nil?
      @state = :open
    end

    def start
      command sensor
    end
  end
end
