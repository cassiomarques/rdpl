module Datamax
  module Element
    ROTATION_0_DEGREES   = 1
    ROTATION_90_DEGREES  = 2
    ROTATION_180_DEGREES = 3
    ROTATION_270_DEGREES = 4
    
    class InvalidRotationError         < StandardError; end
    class InvalidFontIdError           < StandardError; end
    class InvalidWidthMultiplierError  < StandardError; end
    class InvalidHeightMultiplierError < StandardError; end
    class InvalidBarcodeHeightError    < StandardError; end
    class FixedValueError              < StandardError; end
    class InvalidAssigmentError        < StandardError; end

    def initialize(options = {})
      options.each_pair { |option, value| self.send "#{option}=", value }
    end

    def rotation=(rotation)
      raise InvalidRotationError, rotation unless valid_rotation_range.include?(rotation)
      @rotation = rotation
    end

    def rotation
      @rotation || ROTATION_0_DEGREES
    end

    # Sets the element font type. Available types are:
    #
    # Type    Interpretation
    # 0-9     Font
    # A-T     Barcode with human readable text
    # a-z     Barcode without human readable text
    # X       Line, box, polygon, circle
    # Y       Image
    def font_id=(font_id)
      raise InvalidFontIdError unless valid_font_id_ranges.any? { |range| range.include? font_id }
      @font_id = font_id
    end

    def font_id
      @font_id
    end

    # Valid values goes from 1 to 9 and A to O (base 25)
    def width_multiplier=(multiplier)
      raise InvalidWidthMultiplierError, multiplier unless valid_width_or_height_multiplier?(multiplier)
      @width_multiplier = multiplier
    end

    def width_multiplier
      @width_multiplier || 1
    end

    def height_multiplier=(multiplier)
      raise InvalidHeightMultiplierError, multiplier unless valid_width_or_height_multiplier?(multiplier)
      @height_multiplier = multiplier
    end

    # Valid values goes from 1 to 9 and A to O (base 25)
    def height_multiplier
      @height_multiplier || 1
    end

    # Used only by barcode and smooth/scaleble fonts, but has to be present as 000 
    # in other elements.
    def formatted_height
      '000'
    end

    # Interpreted in hundredths of an inch or tenths of millimeters, depending on
    # the measurement used in the printing job.
    def row_position=(position)
      @row_position = position   
    end

    def row_position
      @row_position || 0
    end

    # Interpreted in hundredths of an inch or tenths of millimeters, depending on
    # the measurement used in the printing job.
    #
    # Notice that the limits for this value depend on the printer model.
    def column_position=(position)
      @column_position = position
    end

    def column_position
      @column_position || 0
    end

    def data=(data)
      @data = data
    end

    def data
      @data || ''
    end

    def to_s
      [rotation, font_id, width_multiplier, height_multiplier, formatted_height, 
        formatted_row_position, formatted_column_position, data].join
    end

    private
    def valid_rotation_range
      ROTATION_0_DEGREES..ROTATION_270_DEGREES
    end

    def valid_width_or_height_multiplier_ranges
      [(1..9), ('A'..'O')]
    end

    def valid_width_or_height_multiplier?(multiplier)
      valid_width_or_height_multiplier_ranges.any? { |range| range.include? multiplier }
    end

    def default_rotation; 1; end

    def formatted_row_position
      '%04d' % normalize_number(row_position)
    end

    def formatted_column_position
      '%04d' % normalize_number(column_position)
    end

    def normalize_number(number)
      number.to_s.gsub(/\./, '')
    end
  end
end
