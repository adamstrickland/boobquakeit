require 'sinatra'
require 'sinatra/activerecord'

set :database, 'sqlite://boobquakeit.db'
# puts "the tweets table doesn't exist" if !database.table_exists?('tweets')

# models just work ...
class Tweet < ActiveRecord::Base
  # def to_json
  #   {
  #     :user => self.user,
  #     :text => self.text,
  #     :when => self.created_at,
  #     :url => (self.url.blank? ? '' : self.url),
  #     :type => self.url_type
  #   }.to_json
  # end
end

