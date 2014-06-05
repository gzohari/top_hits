require 'csv'
module TopHits
  class ReportWorker
    include Sidekiq::Worker

    #Not fast, but easy to change. For performance, we can just dump directly
    #with raw sql: 
    #<same select in raw sql> INTO OUTFILE 'reports/<date>.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
    #not as easy to change tough
    def perform(time_ago = 1.month_ago)
      CSV.open("reports/#{Date.current.to_s}.csv", "wb") do |csv|
        csv << ['KEYWORD', 'POSITION', 'URL', 'TITLE', 'DESCRIPTION']
        TopHits::Result.joins(:keyword)
                       .select('keywords.name, rank , url, title, description')
                       .where(results: { created_at: (time_ago..Time.now)})
                       .find_each do |batch| 
                         csv << batch.attributes.values 
                       end
      end
    end
  end
end
