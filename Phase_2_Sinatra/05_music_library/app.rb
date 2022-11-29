require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    albums = repo.all 

    response = albums.map do |album|
      album.title 
    end.join(', ')

    response
  end 

  get '/artists' do
    repo = ArtistRepository.new
    artists = repo.all 
 
    response = artists.map do |artist|
      artist.name  
    end.join(', ')

    response
  end 

  post '/albums' do
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    return ''
  end 

  post '/artists' do
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.id = params[:id]
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    return ''
  end 
  
  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

  get '/all_albums' do
    repo = AlbumRepository.new

    @albums = repo.all

    return erb(:all_albums)
  end
  
end