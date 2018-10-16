require 'sinatra'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/api/test' do
  content_type :json
  {
    bounds: [41, 51, -5, 9],
    points: [{ lat: 43, lon: 0 }],
  }.to_json
end
