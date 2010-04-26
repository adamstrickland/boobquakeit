require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'bootstrap'
require 'eventmachine'
require 'em-http'
require 'json'

url = 'http://stream.twitter.com/1/statuses/filter.json?track=boobquake'

EventMachine.run do
  http = EventMachine::HttpRequest.new(url).get :head => { 'Authorization' => [ 'boobquakeit', 'cohabitat890' ] }

  buffer = ""

  http.stream do |chunk|
    buffer += chunk
    while line = buffer.slice!(/.+\r?\n/)
      tweet = JSON.parse(line)
      Tweet.new(:user => tweet['user']['screen_name'], :text => tweet['text']).save if tweet['text']
    end
  end
end