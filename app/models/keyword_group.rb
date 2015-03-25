class KeywordGroup < ActiveRecord::Base

  belongs_to :industry
  belongs_to :area

  scope :overlapped, ->(kw_array) { where.overlap(keywords: kw_array) }
  scope :keywords, -> { pluck(:keywords).flatten }
  scope :exceptions, -> { pluck(:exceptions).flatten }


  class << self
    def join_keywords(keyword_groups)
      keyword_groups.keywords.map do |kw|
        kw.strip!
        "\"#{kw}\""
      end.join(' | ')
    end

    def join_exceptions(keyword_groups)
      keyword_groups.exceptions.map { |ex| "!\"#{ex}\"" }.join(' ')
    end

    def keyword_query(keyword_groups)
      if keyword_groups.any?
        "#{join_keywords(keyword_groups)} #{join_exceptions(keyword_groups)}"
      end
    end

    def query_str(term)
      keyword_query(overlapped [term]) || "\"#{term}\""
    end
  end

end
