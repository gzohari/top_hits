require 'test_helper.rb'
require 'yaml'

class TopHitsTest < MiniTest::Spec
  # TODO add fixtures

  def test_set_defaults
    assert_empty TopHits::Provider.all

    assert TopHits.set_defaults
    search_providers =  TopHits::Provider.all
    assert_equal search_providers.map(&:name), [ "google", "bing" ]
    search_providers =  TopHits::Provider.all
    assert_equal search_providers.map(&:name), [ "google", "bing" ]
  end

  def test_import
    assert_raises(TopHits::FilePathError) { TopHits.import "" }
    assert_raises(TopHits::MalformedFile) { TopHits.import "test/fixtures/not_xml_file.xml" }

    assert TopHits.import("test/fixtures/rankabove-test.xml")
    assert_equal 6, TopHits::Keyword.count #use const number

    assert_equal YAML.load(File.read("./test/fixtures/rankabove-test-helper.yml"))["keywords"].sort, 
                 TopHits::Keyword.select(&:name).collect(&:name).sort
  end
end
