module PrepareQuery
  extend ActiveSupport::Concern

  module ClassMethods
    def search_query(term)
      KeywordGroup.query_str prepare_search_term(term)
    end

    def prepare_search_term(term)
      term.split(' ').append(term).uniq
    end
  end

end
