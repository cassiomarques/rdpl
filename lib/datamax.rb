$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

module Datamax
  STX      = 2.chr
  CR       = 13.chr
  LF       = 10.chr
  NEW_LINE = CR + LF

  module Commandable
    def command(param)
      @contents << STX << param << NEW_LINE
    end
  end

  module Sensor 
    REFLEXIVE = 'r'
    EDGE      = 'e'
  end
end
