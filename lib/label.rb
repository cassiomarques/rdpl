module Datamax
  class Label
    attr_reader :state, :quantity
    attr_writer :job

    include Commandable

    START            = 'L'
    FINISH           = 'E'
    DEFAULT_DOT_SIZE = 11
    DEFAULT_HEAT     = 14

    def initialize(options = {})
      @contents = ''
      start options
    end

    def dump
      @contents.dup
    end

    def end!
      self << formatted_quantity unless quantity.nil?
      self << FINISH 
      self.state = :finished
    end

    def [](arg)
      @contents[arg]
    end

    def <<(arg)
      raise EndedElementError unless state == :open
      @contents << arg.to_s << NEW_LINE
    end

    def dot_size
      @dot_size || DEFAULT_DOT_SIZE
    end

    def heat
      @heat || DEFAULT_HEAT
    end

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
        element = Datamax.const_get(klass).new
        block.call element
        self << element.to_s
      end
    end

    private
    def start(options = {})
      self.state = :open
      command START
      self << formatted_heat
      self << formatted_dot_size
      options.each_pair { |option, value| self.send("#{option}=", value) }
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
