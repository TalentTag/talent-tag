class KeywordGroup < ActiveRecord::Base

  belongs_to :industry
  belongs_to :area

  scope :overlapped, ->(kw_array) { where.overlap(keywords: kw_array) }

  class << self
    def get_array(field)
      pluck(field.to_sym).flatten.uniq.map{ |el| el unless el.blank? }.compact
    end

    def join_keywords(keyword_groups)
      keyword_groups.get_array(:keywords).map { |kw| "(#{kw})" }.join(' | ')
    end

    def join_exceptions(keyword_groups)
      keyword_groups.get_array(:exceptions).map { |ex| "!(#{ex})" }.join(' ')
    end

    def keyword_subquery(keyword_groups)
      if keyword_groups.any?
        "(#{format_substring keyword_groups})"
      end
    end

    def format_substring(keyword_groups)
      "#{join_keywords keyword_groups} #{join_exceptions keyword_groups}".strip
    end

    def split_search_term(term)
      substrings term.split(' ')
    end

    def substrings(arr)
      (0..arr.length).inject([]) do |ai, i|
        (1..arr.length - i).inject(ai) do |aj, j|
          aj << arr[i, j]
        end
      end.uniq.
      map{ |el| el.join(' ') }
    end

    def splitted_keyword_term(term)
      split_search_term(term).map do |kw|
        keyword_subquery(overlapped [kw])
      end.compact.join(' ')
    end

    def query_str(term)
      if /\".*\"|\(.*\)|\=.*/ =~ term
        term
      elsif /\// =~ term
        "\"#{term}\""
      else
        splitted_keyword_term(term).blank? ? term : splitted_keyword_term(term) + " | (#{term})"
      end
    end
  end

end
