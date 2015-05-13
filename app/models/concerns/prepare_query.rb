module PrepareQuery
  extend ActiveSupport::Concern

  MAX_RESULTS = 100_000

  module ClassMethods
    def search_query(term)
      KeywordGroup.query_str term
    end
  end

end
