require "top_hits/version"
require 'nokogiri'
require 'active_record'
require 'yaml'
require 'erb'

require 'top_hits/model'
require 'top_hits/models/provider'
require 'top_hits/models/keyword'
require 'top_hits/models/result'

require 'top_hits/scraper'
require 'top_hits/cli'

require 'sidekiq'
require 'top_hits/workers/scraper_worker'
require 'top_hits/workers/report_worker'


module TopHits

  class TopHitsError < StandardError ; end
  class FilePathError < TopHitsError
    attr_accessor :test_results
    def initialize(message, test_results=nil)
      super(message)
      @test_results = test_results
    end
  end

  class MalformedFile < TopHitsError
    attr_accessor :test_results
    def initialize(message, test_results=nil)
      super(message)
      @test_results = test_results
    end
  end

  class << self
    def set_defaults(opts={})
      YAML.load_file("./lib/top_hits/config/default_data.yml")["providers"].each do |p|
        provider = Provider.create! p.values
        provider.first.keywords << Keyword.all
      end
    end

    # if xml size is decent, this can replaced with 
    # Nokogiri::XML(file).xpath('//keywords//keyword').map(&:inner_text)
    # This is performance compromise over SAX parser
    def import(file_path)
      File.open(file_path) do |file|
        Nokogiri::XML::Reader(file).each do |node|
          if node.name == 'keyword' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
            TopHits::Keyword::create!(name: node.inner_xml)
          end
        end
      end
      return true
    rescue Errno::ENOENT
      raise TopHits::FilePathError.new($!)
    rescue Nokogiri::SyntaxError
      raise TopHits::MalformedFile.new($!)
    end

    def run_scraper(opts={})
      ScraperWorker.new.perform
    end

    def generate_report(time_ago: 1.month.ago)
      ReportWorker.new.perform(time_ago)
    end
  end

  #egh - FOR CONVINIENCE
  @connection_info = YAML.load(ERB.new(File.read("./test/config/database.yml")).result)
  ActiveRecord::Base.establish_connection(@connection_info)
end

