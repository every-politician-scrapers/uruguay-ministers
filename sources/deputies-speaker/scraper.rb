#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator ReplaceZeroWidthSpaces
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Mandato'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name start end].freeze
    end

    def name_cell
      super.css('b')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
