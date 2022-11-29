require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do 
    reset_albums_table
    reset_artists_table
  end

  context 'GET /albums' do
    it "should return a list of the albums" do
      response = get('/albums')
      expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring' 

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response
    end
  end 

  context 'GET /artists' do
    it "should return a list of the artists" do
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'	

      expect(response.status).to eq 200
      expect(response.body).to eq expected_response
    end
  end 

  context 'POST /albums' do
    it "should create a new album" do
      response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')

      expect(response.status).to eq 200
      expect(response.body).to eq ''

      response = get('/albums')

      expect(response.body).to include('OK Computer')
    end
  end 

  context 'POST /artists' do
    it "should create a new artist" do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')

      expect(response.status).to eq 200
      expect(response.body).to eq ''

      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing'

      expect(response.body).to eq expected_response
    end
  end 

  context "GET /albums" do
    it "should return a single album" do
      response = get('/albums/2')

      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')

    end
  end 

  context "GET all /albums" do
    it "should return all the albums" do
      response = get('/all_albums')

      expect(response.status).to eq 200
      expect(response.body).to include 'Lover'
      expect(response.body).to include 'Folklore'
      expect(response.body).to include 'Released: 1988'
      expect(response.body).to include 'Released: 2020'
    end
  end 
end 
