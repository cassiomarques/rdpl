module Datamax
  class Label
    attr_writer :heat, :dot_size
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
      self << FINISH 
      @state = :finished
    end

    def [](arg)
      @contents[arg]
    end

    def <<(arg)
      @contents << arg << NEW_LINE
    end

    def dot_size
      @dot_size || DEFAULT_DOT_SIZE
    end

    def formatted_dot_size
      "D#{dot_size}"
    end

    def heat
      @heat || DEFAULT_HEAT
    end

    def formatted_heat
      "H#{heat}"
    end

    private
    def start(options = {})
      command START
      self << formatted_heat
      self << formatted_dot_size
      @state = :started
      options.each_pair { |option, value| self.send("#{option}=", value) }
    end
  end
end
