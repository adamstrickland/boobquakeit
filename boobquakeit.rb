require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'erb'
require 'bootstrap'
require 'will_paginate'
# require 'will_paginate/finders/active_record' 

# WillPaginate::ViewHelpers::LinkRenderer.class_eval do
#   protected
#   def url(page)
#     url = @template.request.url
#     if page == 1
#       # strip out page param and trailing ? if it exists
#       url.gsub(/page=[0-9]+/, '').gsub(/\?$/, '')
#     else
#       if url =~ /page=[0-9]+/
#         url.gsub(/page=[0-9]+/, "page=#{page}")
#       else
#         url + "?page=#{page}"
#       end
#     end
#   end
# end


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