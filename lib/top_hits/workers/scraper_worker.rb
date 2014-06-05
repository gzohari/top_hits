module TopHits
  class ScraperWorker
    include Sidekiq::Worker

    def perform
      TopHits::Provider.includes(:keywords).each do |provider|
        TopHits::Model.transaction do
          provider.keywords.find_each do |keyword|
            TopHits::Scraper.new(provider, keyword).scrape(100)
          end
        end
      end
    end
  end
end
