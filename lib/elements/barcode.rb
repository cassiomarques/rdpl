module Datamax
  class Barcode
    include Element

    alias :wide_bar_multiplier :width_multiplier
    alias :wide_bar_multiplier= :width_multiplier=
    alias :narrow_bar_multiplier :height_multiplier
    alias :narrow_bar_multiplier= :height_multiplier=

    DEFAULT_HEIGHT = 25

    def height=(height)
      raise InvalidBarcodeHeightError unless valid_height_range.include?(height)
      @height = height
    end

    def height
      @height || DEFAULT_HEIGHT
    end

    private
    def valid_height_range
      0..999
    end

    def formatted_height
      '%03d' % height
    end

    def valid_font_id_ranges
      [('a'.. 'z'), ('A'..'Z')]
    end
  end
end
