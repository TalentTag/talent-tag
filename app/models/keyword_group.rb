class KeywordGroup < ActiveRecord::Base

  belongs_to :industry
  belongs_to :area

  scope :overlapped, ->(kw_array) { where.overlap(keywords: kw_array) }

  class << self
    def get_array(field)
      pluck(field.to_sym).flatten.uniq.map{ |el| el unless el.blank? }.compact
    end

    def join_keywords(keyword_groups)
      keyword_groups.get_array(:keywords).map { |kw| "\"#{kw}\"" }.join(' | ')
    end

    def join_exceptions(keyword_groups)
      keyword_groups.get_array(:exceptions).map { |ex| "!\"#{ex}\"" }.join(' ')
    end

    def keyword_query(keyword_groups)
      if keyword_groups.any?
        "#{join_keywords(keyword_groups)} #{join_exceptions(keyword_groups)}".strip
      end
    end

    def split_search_term(term)
      term.split(' ').append(term).uniq
    end

    def query_str(term)
      if /\".*\"|\(.*\)|\=.*/ =~ term
        term
      else
        keyword_query(overlapped(split_search_term term)) || "\"#{term}\""
      end
    end
  end

end
