require 'tempfile'

module Rdpl
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

    def sensor; @sensor ||= Sensor::EDGE; end

    def measurement; @measurement ||= :inches; end

    def in?; measurement == :inches; end

    def mm?; measurement == :metric; end

    def <<(label)
      @labels << label
      label.job = self
      @contents << label.dump
      feed
    end
    alias :add_label :<<

    def dump; @contents.dup; end

    def feed; command FEED; end

    def print
      tempfile = Tempfile.new 'datamax_label'
      tempfile << dump
      tempfile.close
      Kernel.system "lpr -P #{printer} #{tempfile.path}"
    end

    private
    def printer=(printer); @printer = printer; end
    def measurement=(measurement); @measurement = measurement; end

    def initialize_options(options)
      validate_measurement_option options[:measurement]
      options.each_pair { |option, value| self.send("#{option}=", value) }  
      raise MissingPrinterNameError if printer.nil?
      @state = :open
    end

    def start; command sensor; end

    def validate_measurement_option(option)
      raise ArgumentError, 'should be :metric or :inches' unless [nil, :metric, :inches].include?(option)
    end
  end
end
