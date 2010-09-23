require 'tempfile'

module Rdpl
  # A +Job+ instance represents a print job to be sent to the printer. A print job 
  # may contain a list of instances of Rdpl::Label.
  #
  # The default process to send jobs to the printer is configuring the printer in
  # cups and passing the printer's cups identifier to the constructor. Rdpl will use
  # this id and issue something like +lpr -P cups_id some_temp_file+. This makes this lib
  # unusable if you're not on some kind of *nix box.
  class Job
    attr_reader :labels, :printer, :state
    attr_writer :sensor

    include Commandable
    include Enumerable

    # Creates a new instance of Rdpl::Job
    #
    # Example:
    #
    #   job = Rdpl::Job.new :printer => "some_cups_id"
    #
    # The possible options are:
    #
    # * <tt>:printer</tt> the cups id of the printer to be used. This option is required.
    # * <tt>:sensor</tt> the type of sensor to be used. Can be one of <tt>Rdpl::Sensor::REFLEXIVE</tt> or <tt>Rdpl::Sensor::EDGE</tt>. This is optional and defaults to <tt>Rdpl::Sensor::EDGE</tt>
    # * <tt>:measurement</tt> the measurement system to be used. Can be one of :inches or :metric. For metric, mm will be used as unit. This is optional and defaults to <tt>:inches</tt>.
    def initialize(options = {})
      initialize_options options
      @contents = ''
      start
      @labels = []
    end

    # Yields each <tt>Rdpl::Label</tt> instance contained in this job.
    def each
      @labels.each { |label| yield label }
    end

    # Returns the current sensor type. If no <tt>:sensor</tt> option was specified, defaults 
    # to <tt>Rdpl::Sensor::EDGE</tt>.
    def sensor; @sensor ||= Sensor::EDGE; end

    # Returns the current measurement system in use.
    def measurement; @measurement ||= :inches; end

    # Returns <tt>true</tt> if the current measurement system is <tt>:inches</tt>.
    def in?; measurement == :inches; end

    # Returns <tt>true</tt> if the current measurement system is <tt>:metric</tt>.
    def mm?; measurement == :metric; end

    # Adds a new <tt>Rdpl::Label</tt> to be printed in this job. After a label in added, 
    # the job will insert a <tt>FEED</tt> command (<tt>STX F <CR><LF></tt>).
    def <<(label)
      @labels << label
      label.job = self
      @contents << label.dump
      feed
    end
    alias :add_label :<<

    # Dumps the contents to be printed to a string.
    def dump; @contents.dup; end

    # Insert a <tt>FEED</t> command (<tt>STX F <CR><LF></tt>).
    def feed; command FEED; end

    # Sends the job's contents to the printer. The destination will be the cups
    # printer id informed in the job's creation.
    #
    # The printing process is very simple, Rdpl will create a temp file and issue a <tt>lpr</tt> system 
    # command using the cups printer id and this file. 
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
