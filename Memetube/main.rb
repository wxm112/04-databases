require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'youtube_addy'

require 'pry'

before do
    @genres = db_query("SELECT DISTINCT(genre) FROM metube")
end

get '/' do
  erb :home
end

get '/videos' do 
    @videos = db_query("SELECT * FROM metube")
    erb :index
end

get '/videos/genre/:name' do
  @videos = db_query("SELECT * FROM metube WHERE genre='#{params[:name]}'")
  erb :index
end

get '/videos/new' do 
    erb :new
end

get '/videos/:id' do
  id = params[:id]
  @video = db_query("SELECT * FROM metube WHERE id = #{ id }")
  @video = @video.first
  @embed_code = YouTubeAddy.extract_video_id(@video['url'])
  erb :show
end

get '/videos/:id/delete' do
  id = params[:id]

  db_query("DELETE FROM metube WHERE id = #{ id }")

  redirect to('/videos')
end

get '/videos/:id/edit' do
  id = params[:id]

  @video = db_query("SELECT * FROM metube WHERE id = #{ id }").first

  erb :edit
end

post '/videos/:id' do
  id = params[:id]

  query = "UPDATE metube SET title='#{params["title"]}', description='#{params["description"]}', url='#{params["url"]}', genre='#{params["genre"]}' WHERE id = #{id}"

  db_query(query)

  redirect to('/videos/' + id)
end

post '/videos' do
    query = "INSERT INTO metube (title, description, url, genre)
           VALUES ('#{params["title"]}', '#{params["description"]}',
                   '#{params["url"]}', '#{params["genre"]}')"
    db_query(query)
    redirect to ("/videos")
end

def db_query(sql)
  db = SQLite3::Database.new "metube.db"
  db.results_as_hash = true

  result = db.execute sql

  db.close
  result
end