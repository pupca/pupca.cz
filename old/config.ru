root = ::File.dirname(__FILE__)
require ::File.join( root, 'main' )

run Sinatra::Application
