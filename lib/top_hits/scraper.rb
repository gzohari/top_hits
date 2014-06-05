require 'mechanize'

module TopHits
  class Scraper

    DEFAULT_SEARCH_FORM_IDENTIFIER = { action: "/search" }
    DEFAULT_SEARCH_BOX_NAME = 'q'

    attr_reader :provider, :keyword, :agent

    def initialize(search_provider, keyword_to_search, user_agent = 'Mac Safari')
      @provider = search_provider
      @keyword = keyword_to_search
      @agent = Mechanize.new {|agent| agent.user_agent_alias = user_agent }
    end

    def scrape(user_agent='Mac Safari', num_results_to_get = 100)
      results_page = search_keyword 
      save_all_results(results_page, num_results_to_get)
    end

    private

    def search_keyword
      page = agent.get(provider.search_url)
      search_box = find_search_form_in_page(page) 
      set_keyword_in_searchbox(keyword, search_box).submit
    end

    def find_search_form_in_page(page)
      page.form_with( provider.search_box_identifier ) || 
      page.form_with( DEFAULT_SEARCH_FORM_IDENTIFIER )
    end

    def set_keyword_in_searchbox(keyword, search_box)
      search_box.send("#{ provider.search_box_name ||
                          DEFAULT_SEARCH_BOX_NAME }=" , keyword.name)
      search_box
    end

    def parse_result_args(result_node)
      return  { title: result_node.search(provider.title_identifier).text,
                url: result_node.search(provider.url_identifier).text,
                description: result_node.search(provider.description_identifier).text }
    end

    def next_result_page(results_page)
      next_page_link = results_page.at(provider.next_page_identifier)
      return if !next_page_link

      results_page.link_with(href: next_page_link[:href]).click
    end

    def save_all_results(results_page, num_results_to_get)
      max = num_results_to_get
      while results_page && (num_results_to_get > 0)
        sleep(1) # STOP BANNING ME GOOGLE

        num_results_to_get = save_page_results(results_page, max, num_results_to_get)
        return if !num_results_to_get
        results_page = next_result_page(results_page)
      end
    end

    def save_page_results(results_page, max_rank,  results_left_to_get)
      find_results(results_page).each do |raw_res|
        results_left_to_get -= 1
        save_result(raw_res, max_rank - results_left_to_get)
        return if results_left_to_get == 0
      end
      results_left_to_get
    end

    def find_results(results_page)
      results_page.search(provider.result_identifier)
    end

    def save_result(raw_res,rank)
      res = TopHits::Result.new(parse_result_args(raw_res) .merge({rank: rank}))
      res.provider, res.keyword = provider, keyword
      res.save!
    end
  end
end

