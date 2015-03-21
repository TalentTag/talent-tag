class KeywordGroup < ActiveRecord::Base

  belongs_to :industry
  belongs_to :area

  scope :overlapped_keywords, ->(kw_array) { where.overlap(keywords: kw_array).pluck(:keywords).flatten }

  class << self
    def join_keywords(keywords)
      keywords.any? && keywords.map do |kw|
        kw.strip.include?(" ") ? "\"#{kw.strip}\"" : "=#{kw.strip}"
      end.join(' | ') || nil
    end

    def query_str(term)
      join_keywords(overlapped_keywords term) || term
    end
  end

end
