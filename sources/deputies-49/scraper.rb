#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class SpanishExt < WikipediaDate::Spanish
  def date_en
    super.gsub(/[º°]/, '')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Banca'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name col party list constituency start end notes].freeze
    end

    def date_class
      SpanishExt
    end

    def empty?
      tds[0].text.tidy.include? 'Presidente'
    end

    #TODO: party + constituency
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
