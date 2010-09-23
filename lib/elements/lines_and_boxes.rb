module Rdpl
  module LinesAndBoxes
    attr_writer :vertical_width, :horizontal_width

    include Element
    include Graphic

    # Returns the element's vertical width. Defaults to 0.
    def vertical_width
      @vertical_width || 0
    end

    # Returns the element's horizontal width. Defaults to 0.
    def horizontal_width
      @horizontal_width || 0
    end

    def width_multiplier=(multiplier) # :nodoc:
      raise FixedValueError, 'for lines width multiplier is fixed to 1'
    end

    def height_multiplier=(multiplier) # :nodoc:
      raise FixedValueError, 'for lines height multiplier is fixed to 1'
    end

    def font_id # :nodoc:
      'X'
    end

    private
    def formatted_horizontal_width
      '%04d' % normalize_number(horizontal_width)
    end

    def formatted_vertical_width
      '%04d' % normalize_number(vertical_width)
    end
  end
end
