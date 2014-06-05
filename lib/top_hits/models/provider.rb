module TopHits
  class Provider < TopHits::Model
    serialize :search_box_identifier
    serialize :results_identifier

    has_and_belongs_to_many :keywords
    has_many :results
  end
end
