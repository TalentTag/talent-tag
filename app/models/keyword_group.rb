class KeywordGroup < ActiveRecord::Base

  belongs_to :industry
  belongs_to :area

  scope :overlapped, ->(kw_array) { where.overlap(keywords: kw_array) }

  class << self
    def get_array(field)
      pluck(field.to_sym).flatten.uniq.reject{ |el| el.blank? }.compact
    end

    def join_keywords(keyword_groups)
      keyword_groups.get_array(:keywords).map { |kw|  kw.single? ? "=#{kw}" : "(#{kw})" }.join(' | ')
    end

    def join_exceptions(keyword_groups)
      keyword_groups.get_array(:exceptions).map { |ex| "!(#{ex})" }.join(' ')
    end

    def keywords_with_exceptions(keyword_groups)
      "#{join_keywords keyword_groups} #{join_exceptions keyword_groups}".strip
    end

    def keyword_subquery(keyword_groups)
      "(#{keywords_with_exceptions keyword_groups})"
    end

    def substrings(arr)
      (0..arr.length).inject([]) do |ai, i|
        (1..arr.length - i).inject(ai) do |aj, j|
          aj << arr[i, j]
        end
      end.uniq.
      map{ |el| el.join(' ') }
    end

    def split_search_term(term)
      substrings term.split(' ')
    end

    def terms_to_replace(kw)
      kw_group = overlapped([kw])

      [
        kw,
        keyword_subquery(kw_group)
      ] unless kw_group.blank?
    end

    def splitted_keyword_term(term)
      split_search_term(term).map do |kw|
        terms_to_replace kw
      end.compact
    end

    def substitute_keywords(term)
      splitted_keyword_term(term).each do |substr_arr|
        term.gsub!(substr_arr[0], substr_arr[1])
      end

      term
    end

    def query_str(term)
      if /\".*\"|\(.*\)|\=.*/ =~ term
        term
      elsif /\// =~ term
        "\"#{term}\""
      else
        substitute_keywords term if term
      end
    end
  end

end
