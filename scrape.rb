require 'mechanize'
require 'pry'
require 'csv'

BASE_URL = 'http://sfbay.craigslist.org'
ADDRESS = 'http://sfbay.craigslist.org/search/sfc/apa'


class Scraper
	attr_accessor :results
	def initialize
		@results
		@scraper = Mechanize.new
		@scraper.history_added = Proc.new { sleep 0.5 }

		@results = []
	end

	def get_info
		@search_page = @scraper.get(ADDRESS)
		@search_page
	end

	def search_page
		search_page = get_info
		@search_form = search_page.form_with(:id => 'searchform') do |search|
		  search['query'] = 'Studio'
		  search['min_price'] = 1000
		  search['max_price'] = 1500
		end
	   @results = @search_form.submit
	end

	def results
		results = search_page
		raw_results = results.search('p.result-info')
		raw_results
	end

	def parse_results
		raw = results
		binding.pry
		raw
		#raw.each do |result|
		#	link = result.search('a')[1]
		#	pp link
		#end
	end
end

scrape = Scraper.new

scrape.parse_results