module Rdpl
  class Line 
    DEFAULT_CHARACTER = 'l'

    include LinesAndBoxes

    def data      
      DEFAULT_CHARACTER + formatted_horizontal_width + formatted_vertical_width
    end
  end
end
