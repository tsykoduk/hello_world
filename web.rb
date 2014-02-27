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
    "<p>Hello, "  << ENV['NAME'] << "!</p>" <<
    "<p>What would you like to do today?</p>" <<
    "<ul><li><a href='/protected'>Access a secure page?</a></li>"<<
    "<li><a href='/slow'>Load a slow page?</a></li>"<<
    "<li><a href='/rand-slow'>Load a randomly slow page</a></li>"<<
    "<li><a href='/bloat'>Load a page that will leak ram</a></li></ul>"
end

get '/protected' do
  protected!
  "Hi there, Mr Secure User Named " << ENV['NAME']
end

get '/slow' do
    #protected!
		sleep(2)
        "Hello, " << ENV['NAME'] << "! This is a slow request"
end

get '/rand-slow' do
  #protected!
  if rand() > 0.75
    sleep(10 * rand())
  else
    sleep(1 * rand())
  end
  "Hello, " << ENV['NAME'] << "! This is a randomly slow request"
end

get '/bloat' do
  y = `cat text.txt`
  1000.times do |n|
    big_array << y + rand().to_s + n.to_s
  end
  "<p>woah</p><p>Hello, " << ENV['NAME'] << "! This should use a lot of RAM </p>"
end
