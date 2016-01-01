# encoding: utf-8

require 'sinatra'
require 'pony'
#require "ap"

get '/' do
  @success = true if params[:success] == "true"
  erb :index
end

post '/send' do
  Pony.mail :to => "pupca@pupca.cz",
  :subject => "[Pupca.cz] - Zprava od #{Rack::Utils.escape_html(params[:name])}",
  :from => params[:email],
  :body => Rack::Utils.escape_html(params[:message])
  redirect "/?success=true#contact"

end

