require 'sinatra'
require 'sinatra/activerecord'

set :database, 'sqlite://boobquakeit.db'
# puts "the tweets table doesn't exist" if !database.table_exists?('tweets')

# models just work ...
class Tweet < ActiveRecord::Base
end

