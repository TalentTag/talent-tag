require 'rails_helper'

RSpec.describe KeywordGroup, type: :model do
  it { should belong_to(:industry) }
  it { should belong_to(:area) }


  describe '.query_str' do
    context 'strict query' do
      it 'should return quoted string for query' do
        expect(KeywordGroup.query_str("\"this is a strict query\"")).to eq "\"this is a strict query\""
      end
    end

    context 'non-strict query' do
      let!(:pr) { create :keyword_group, keywords: ['PR', 'public relations'], exceptions: [] }
      let!(:pr_dup) { create :keyword_group, keywords: ['PR', 'page rank'], exceptions: [] }
      let!(:horeca) { create :keyword_group, keywords: ['HoReCa', 'Hotel Restaurant Cafe'], exceptions: [] }
      let!(:admin) { create :keyword_group, keywords: ['administrator', 'manager'], exceptions: ['system', 'linux'] }

      it 'find uniq keywords for single word' do
        expect(KeywordGroup.query_str("PR")).to eq "\"PR\" | \"public relations\" | \"page rank\""
      end

      it 'find uniq keywords for keyword phrase' do
        expect(KeywordGroup.query_str("public relations")).to eq "\"PR\" | \"public relations\""
      end

      it 'should add all keywords to query' do
        expect(KeywordGroup.query_str("PR HoReCa")).to eq(
          "\"PR\" | \"public relations\" | \"page rank\" | \"HoReCa\" | \"Hotel Restaurant Cafe\""
        )
      end

      it 'should add exceptions if present' do
        expect(KeywordGroup.query_str("administrator")).to eq "\"administrator\" | \"manager\" !\"system\" !\"linux\""
      end
    end
  end
end
