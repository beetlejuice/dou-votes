require 'votes_parser'
require 'votes_manager'
require 'config/config'

parser = VotesParser.new(Config.company_url)
manager = VotesManager.new

def get_new_votes_count
  previous_votes = manager.get_stored_votes_number
  new_votes = parser.get_votes_number
  new_votes - previous_votes
end

new_votes_count = get_new_votes_count
if new_votes_count > 0
  if new_votes_count == 1
    new_vote = manager.calculate_user_vote
    manager.store_user_vote(new_vote)
  end

  manager.store_votes_number(new_votes_count)
  new_votes_statistics = parser.get_votes_statistics
  manager.store_statistics(new_votes_statistics)
end