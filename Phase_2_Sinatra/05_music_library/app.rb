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
  
  get '/albums/new' do
    
    return erb(:new_album)
  end

  post '/albums' do

    @album_name = params[:title]

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    return erb(:album_created)
  end 

  get '/artists/new' do

    return erb(:new_artist)
  end

  post '/artists' do

    @artist_name = params[:name]

    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    return erb(:artist_created)
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
  
  get '/artist/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    return erb(:artist)
  end 

  get '/all_artists' do
    repo = ArtistRepository.new

    @artists = repo.all

    return erb(:all_artists)
  end 


end