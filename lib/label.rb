module Datamax
  class Label
    attr_writer :heat, :dot_size
    attr_reader :state
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
      self.state = :finished
    end

    def [](arg)
      @contents[arg]
    end

    def <<(arg)
      raise EndedElementError unless state == :open
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
      self.state = :open
      command START
      self << formatted_heat
      self << formatted_dot_size
      options.each_pair { |option, value| self.send("#{option}=", value) }
    end

    def state=(_state)
      @state = _state
    end
  end
end
