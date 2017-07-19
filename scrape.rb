require 'mechanize'
require 'pry'
require 'csv'

BASE_URL = 'http://sfbay.craigslist.org'
ADDRESS = 'http://sfbay.craigslist.org/search/sby/apa'


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
		parsed_info = []
		#binding.pry
		raw
		raw.each do |result|
			link = result.search('a')[0]
			name = link.text.strip
			url = BASE_URL + link.attributes["href"].value
			price = result.search('span.result-price').text
			location = result.search('span.result-hood').text
			parsed_info << [name, url, price, location]
        end
        
        parsed_info
	end

	def save_parsed_results
		data = parse_results
		
		CSV.open("apartments.csv", "w+", headers:true) do |csv_file|
			data.each do |row|
				
				csv_file << row
			end
		end
	end
end

scrape = Scraper.new

scrape.save_parsed_results