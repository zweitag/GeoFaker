require 'sinatra'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/test' do
  'omg what is this?'
end
