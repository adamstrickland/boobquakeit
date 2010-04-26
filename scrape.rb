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