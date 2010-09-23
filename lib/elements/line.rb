module Rdpl
  # Represents a line to be printed in the label.
  class Line 
    DEFAULT_CHARACTER = 'l'

    include LinesAndBoxes

    def data      
      DEFAULT_CHARACTER + formatted_horizontal_width + formatted_vertical_width
    end
  end
end
