require 'sinatra'
require 'sinatra/reloader' if development?


get '/' do
  message = "Hello world."

  erb :index, :locals => {:message => message}
end