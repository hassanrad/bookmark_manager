ENV['RACK_ENV'] ||= 'development'
# APP_ROOT = File.expand_path File.join(__dir__, "..")
# RACK_ENV = ENV['RACK_ENV']
# Bundler.require(:default, RACK_ENV)

require 'sinatra/base'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base

  enable :sessions
  set :session_secret, "super secret"

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new_link'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    params[:tags].split(",").each do |x|
     x.strip!
     tag = Tag.first_or_create(name: x)
     link.tags << tag
    end
    link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect '/links'
  end

  helpers do
    def current_user
      @current_user ||=User.get(session[:user_id])
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
