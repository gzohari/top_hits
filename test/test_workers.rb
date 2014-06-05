require 'test_helper.rb'

class WorkerTest < MiniTest::Spec
  def setup
     @provider = TopHits::Provider.new  *YAML.load_file("./lib/top_hits/config/default_data.yml")["providers"].first.values
     @keyword = TopHits::Keyword.new name: 'foo'

     @scraper = TopHits::Scraper.new @provider, @keyword
  end

  def test_scraper_no_res
    assert_equal 0, TopHits::Result.count
     zero_keyword = TopHits::Keyword.new name: 'asdlkfjhalskdjnvalksdjnbvlaksdjnlvkasdjbnlak;sdjnvklasdfjvbnalkdsbfjvadsfvadsfv'
     assert TopHits::Scraper.new @provider, zero_keyword
    assert_equal 0, TopHits::Result.count
  end

  def test_save_results_less_than_max
    assert_equal 0, TopHits::Result.count
    cur_dir = File.dirname(__FILE__)
    fake_page = Mechanize.new.get("file:///#{cur_dir}/fixtures/demon_jesus_baby__Google_Search.html")
    Mechanize.any_instance.stubs(:get).returns fake_page
    @scraper.scrape
    assert_equal 7 , TopHits::Result.count
  end
end
