$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rdpl'
require 'spec'
require 'spec/autorun'

Dir.glob(File.join(File.dirname(__FILE__), 'shared_examples/*.rb')).each {|f| require f }

Spec::Runner.configure do |config|
  
end
