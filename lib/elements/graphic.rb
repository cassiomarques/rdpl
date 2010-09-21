module Rdpl
  module Graphic
    def font_id
      'X'
    end

    def data=(data)
      raise Element::InvalidAssigmentError, 'You cannot assign data to graphic elements'
    end
  end
end
