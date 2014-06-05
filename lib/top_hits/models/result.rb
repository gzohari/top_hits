module TopHits
  class Result < TopHits::Model
    belongs_to :keyword
    belongs_to :provider
  end
end
