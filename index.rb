require 'rubygems'
require 'erb'
require 'sinatra'

get '/' do
	erb :index
end

