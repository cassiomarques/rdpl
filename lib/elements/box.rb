module Rdpl
  class Box
    attr_writer :bottom_and_top_thickness, :sides_thickness

    DEFAULT_CHARACTER = 'b'

    include LinesAndBoxes

    def bottom_and_top_thickness
      @bottom_and_top_thickness || 0
    end

    def sides_thickness
      @sides_thickness || 0
    end

    def data
      DEFAULT_CHARACTER + 
      formatted_horizontal_width + 
      formatted_vertical_width +
      formatted_bottom_and_top_thickness + 
      formatted_sides_thickness
    end

    private
    def formatted_bottom_and_top_thickness
      '%04d' % normalize_number(bottom_and_top_thickness)
    end

    def formatted_sides_thickness
      '%04d' % normalize_number(sides_thickness)
    end
  end
end
