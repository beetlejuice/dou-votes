require 'sinatra'
require 'votes_manager'
require 'votes_parser'
require 'config/config'


get '/' do
  # Show statistics
  # Show user ratings
end

post '/start-monitoring' do
  initial_statistics = VotesParser.new(Config.company_url).get_votes_statistics
  VotesManager.new.store_statistics(initial_statistics)
end

