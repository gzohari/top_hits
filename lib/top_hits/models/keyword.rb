module TopHits
  class Keyword < TopHits::Model
    has_and_belongs_to_many :providers
    has_many :results
  end
end
