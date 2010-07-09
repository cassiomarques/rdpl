module Datamax
  class Job
    attr_reader :contents, :labels
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
    end

    private
    def initialize_options(options)
      options.each_pair { |option, value| self.send("#{option}=", value) }  
    end

    def start
      command sensor
    end
  end
end
