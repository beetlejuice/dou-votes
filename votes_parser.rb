require 'open-uri'
require 'nokogiri'

VOTES_NUMBER_LOCATOR_CSS = "div#votersWidgetId > div.title > span"
VOTER_IMG_LOCATOR_CSS = "div#votersWidgetId > ul > li > a > div > img"
QUESTION_BLOCK_LOCATOR_CSS = "div#companyPollResultsId > div.l-question > ul > li"
QUESTION_TITLE_LOCATOR_CSS = "div.title"
QUESTION_STAT_LOCATOR_CSS = "div.info > em"

class VotesParser
  attr_reader :page

  def initialize(page_url)
    @page = Nokogiri::HTML(open(page_url))
  end

  def get_votes_number
    votes_string = @page.at_css(VOTES_NUMBER_LOCATOR_CSS).text
    votes_string[/^\d+/].to_i
  end

  def get_voters_list
    @page.css(VOTER_IMG_LOCATOR_CSS).map { |node| node.attribute('title') }
  end

  def get_votes_statistics
    stat = {}
    question_nodes = @page.css(QUESTION_STAT_LOCATOR_CSS)
    question_nodes.each do |node|
      question = node.css(QUESTION_TITLE_LOCATOR_CSS).text
      question_stat_str = node.css(QUESTION_STAT_LOCATOR_CSS).attribute('title')
      question_stat = parse_question_stat(question_stat_str)
      stat[question] = question_stat
    end
    stat
  end

  private

  def parse_question_stat(votes_string)
    question_stat = {}
    votes_string.scan(/([а-яА-Я ]+: \d+).?/).flatten.each do |answer_str|
      answer_key = answer_str.scan(/.+(?=: \d+)/)
      answer_value = answer_str.scan(/(?<=: )\d+/)
      question_stat[answer_key] = answer_value
    end
    question_stat
  end
end
