require 'test_helper.rb'

class TestScraper < MiniTest::Spec
  def setup
     @google = TopHits::Provider.new(*YAML.load_file(
       "./lib/top_hits/config/default_data.yml")["providers"]
       .detect{ |p| p.keys.first == "google" }.values)
     @bing = TopHits::Provider.new(*YAML.load_file(
       "./lib/top_hits/config/default_data.yml")["providers"]
       .detect{ |p| p.keys.first == "bing" }.values)

     @keyword = TopHits::Keyword.new name: 'foo'
     @scraper = TopHits::Scraper.new @google, @keyword
  end

  def test_save_results_less_than_max
    assert_equal 0, TopHits::Result.count
    cur_dir = File.dirname(__FILE__)
    fake_page = Mechanize.new.get("file:///#{cur_dir}/fixtures/demon_jesus_baby__Google_Search.html")
    Mechanize.any_instance.stubs(:get).returns fake_page
    TopHits::Scraper.new(@google, @keyword).scrape
    assert_equal 7 , TopHits::Result.count
  end

  def test_save_results_more_than_max
    assert_equal 0, TopHits::Result.count
    TopHits::Scraper.new(@bing, @keyword).scrape
    assert_equal 100 , TopHits::Result.count
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
    fake_page = Mechanize.new.get("file:///#{cur_dir}/fixtures/demon_jesus_baby__Google_Search.html") # don't judge me, finding oneage res is hard :p
    Mechanize.any_instance.stubs(:get).returns fake_page
    @scraper.scrape
    assert_equal 7 , TopHits::Result.count
  end
end
