module Rdpl
  class BitmappedText
    include Element

    private
    def valid_font_id_ranges
      [(0..9)]
    end
  end
end
