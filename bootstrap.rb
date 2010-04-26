require 'sinatra'
require 'sinatra/activerecord'
require 'activerecord'

dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig['production']

# set :database, 'sqlite://boobquakeit.db'
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

