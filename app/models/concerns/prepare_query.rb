module PrepareQuery
  extend ActiveSupport::Concern

  module ClassMethods
    def search_query(term)
      KeywordGroup.query_str term
    end
  end

end
