$:.unshift *Dir[File.dirname(__FILE__) + "/vendor/*/lib"]

require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'erb'
require 'will_paginate'
require 'active_record'
require 'eventmachine'
require 'em-http'
require 'json'
require 'delayed_job'
require 'open-uri'

configure do
  config = YAML::load(File.open('config/database.yml'))
  environment = Sinatra::Application.environment.to_s
  ActiveRecord::Base.logger = Logger.new($stdout)
  ActiveRecord::Base.establish_connection(
    config[environment]
  )
end

class Tweet < ActiveRecord::Base
end

class Scraper
  def initialize()
    @url = 'http://stream.twitter.com/1/statuses/filter.json?track=boobquake'
  end

  def perform
    EventMachine.run do
      http = EventMachine::HttpRequest.new(@url).get :head => { 'Authorization' => [ 'boobquakeit', 'cohabitat890' ] }

      buffer = ""

      http.stream do |chunk|
        buffer += chunk
        while line = buffer.slice!(/.+\r?\n/)
          tweet = JSON.parse(line)
          if tweet['text'] 
            if tweet['text'] =~ /^.*https?:.*$/
              Tweet.new(
                :user => tweet['user']['screen_name'], 
                :text => tweet['text'], 
                :url => "http://twitter.com/#{tweet['user']['screen_name']}/statuses/#{tweet['id']}",
                :url_type => (tweet['text'] =~ /^.*(twitpic).*$/ ? 'pic' : 'unk')
              ).save
            end
          end
        end
      end
    end
  end
end

Delayed::Job.enqueue Scraper.new


get '/' do
	erb :index
end

get '/tweets' do
  @tweets = Tweet.find(:all, :order => "created_at DESC", :limit => 25).reverse
  @tweets.to_json
end

get '/more/:last' do
  if params[:last]
    @tweets = Tweet.find(:all, :conditions => ['id > ?', params[:last].to_i])
    @tweets.to_json
  end
end

