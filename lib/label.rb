module Rdpl
  # Represents a label to be printed. Labels must me included in an instance of <tt>Rdpl::Job</tt>.
  class Label
    attr_reader :state, :quantity
    attr_writer :job

    include Commandable

    START            = 'L'
    FINISH           = 'E'
    DEFAULT_DOT_SIZE = 11
    DEFAULT_HEAT     = 14

    # Creates a new instance of <tt>Rdpl::Label</tt>
    #
    # Available options are:
    #
    # * <tt>:heat</tt> the heat setting to be used when printing this label. This is optional and defaults to 14.
    # * <tt>:dot_size</tt> the dot size to be used when printing this label. This is optional and defaults to 11.
    # * <tt>:start_of_print</tt> the inicial position to start printing the label. This is optional and has no default value, since this setting depends on the printer model.
    # * <tt>:quantity</tt> the number of copies of this label to be printed.
    def initialize(options = {})
      @contents = ''
      start options
    end

    # Dumps this label's contents to a string.
    def dump
      @contents.dup
    end

    # Closes this label for edition. This appends DPL specific commands to the label, 
    # so the printer knows where the printing must end and where another label is started.
    def end!
      self << formatted_quantity unless quantity.nil?
      self << FINISH 
      self.state = :finished
    end

    def [](arg) # :nodoc:
      @contents[arg]
    end

    # Adds a new element to this label. 
    # An element can be one of the following:
    # * <tt>Rdpl::Barcode</tt>
    # * <tt>Rdpl::BitmappedText</tt>
    # * <tt>Rdpl::Box</tt>
    # * <tt>Rdpl::Line</tt>
    # * A simple string containing DPL commands
    def <<(arg)
      raise EndedElementError unless state == :open
      @contents << arg.to_s << NEW_LINE
    end

    # Returns the current dot size.
    def dot_size
      @dot_size || DEFAULT_DOT_SIZE
    end

    # Returns the current heat setting to be used when printing.
    def heat
      @heat || DEFAULT_HEAT
    end

    # Returns <tt>true</tt> if this label's job is setted to use millimeters as measurement unit.
    # I the label does not have a job yet, it will return <tt>false</tt>.
    def mm?
      @job ? @job.mm? : false
    end

    # Returns the start of print position for the label.
    # If the option wasn't specified in the label's constructor, nil will be returned 
    # and the printer will assume the default start of print.
    #
    # It works this way since the default value for this parameter depends on the printer's model.
    def start_of_print
      return nil if @start_of_print.nil?
      @start_of_print.to_f / (mm? ? 10 : 100)
    end

    {:line           => 'Line',
     :box            => 'Box',
     :barcode        => 'Barcode',
     :bitmapped_text => 'BitmappedText'
    }.each_pair do |kind, klass|
      define_method "add_#{kind}" do |&block|
        element = Rdpl.const_get(klass).new
        block.call element
        self << element.to_s
      end
    end

    private
    def start(options = {})
      self.state = :open
      command START
      options.each_pair { |option, value| self.send("#{option}=", value) }
      self << formatted_heat
      self << formatted_dot_size
    end

    [:state, :heat, :dot_size, :start_of_print, :quantity].each do |method|
      define_method "#{method}=" do |value| 
        self.instance_variable_set :"@#{method}", value
      end
    end
    public :quantity=

    def formatted_dot_size
      "D#{dot_size}"
    end

    def formatted_heat
      "H#{heat}"
    end

    def formatted_quantity
      "Q#{'%04d' % quantity}"       
    end
  end
end
