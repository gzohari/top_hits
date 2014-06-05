require 'optparse'

module TopHits
  class Cli
    attr_accessor :options

    def initialize
      @options = Hash.new
    end

      def parse(args=ARGV)
        OptionParser.new do  |opts|
          opts.banner = "Usage: top_hits [options]"

          opts.on("-i", "--import [XML file]", 
                  "Import keywords from xml file") do |file|
            options[:import] = file
          end

          opts.on("-d", "--default", "Add default data to DB", 
                  "Adds default search engines according to top_hits/config/default_data.yml",
                  "Associates defalut search engines to all keywords") do 
            options[:set_defaults] = {}
          end

          opts.on("-s", "--scrape", "Run scraping worker NOW for all keywords and providers") do 
            options[:run_scraper] = {}
          end

          opts.on("-r", "--report [TIME AGO]", "generate scraping report from the last TIME AGO (default 30 days)") do |time_ago|
            options[:generate_report] = time_ago ? {time_ago: time_ago} : {}
          end
        end.parse!
      end

      def run
        options.each do |k,v|
          TopHits.send(k,v)
        end
      end
  end
end
