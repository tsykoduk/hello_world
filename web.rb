# web.rb
require 'rubygems'
require 'sinatra'

big_array = []

helpers do
          def protected!
            unless ENV['RACK_ENV'] != 'staging' || authorized?
                    response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
                    throw(:halt, [401, "Not authorized\n"])
            end
          end
        
          def authorized?
            @auth ||=  Rack::Auth::Basic::Request.new(request.env)
            @auth.provided? && @auth.basic? && @auth.credentials && 
            @auth.credentials == ['alladin', 'opensesame']
          end
      end

get '/' do
    "Hello, "  << ENV['NAME']
end 

get '/protected' do
  protected!
  "Hi there, Mr Secure User Named " << ENV['NAME']
end

get '/slow' do
    #protected!
		sleep(2)
        "Hello, " << ENV['NAME']
end

get '/rand-slow' do
  #protected!
  if rand() > 0.75
    sleep(10 * rand())
  else
    sleep(1 * rand())
  end
end

get '/bloat' do
  "woah"
  y = `cat text.txt`
  1000.times do |n|
    big_array << y + rand().to_s + n.to_s
  end
end
