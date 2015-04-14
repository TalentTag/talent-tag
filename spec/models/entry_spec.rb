require 'rails_helper'

RSpec.describe Entry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:source) }
  it { should have_many(:comments) }
  it { should have_many(:duplicates) }

  it { should validate_presence_of(:id) }
  it { should validate_presence_of(:body) }

  context 'location_like' do
    let!(:moscow_entry) { create :entry, location: "Moscow, Russia" }
    let!(:urupinsk_entry)  { create :entry, location: "Urupinsk'on'Barenduin, Russia" }

    context 'scope acts as trimmed ilike' do
      context 'when lexeme present only in one location' do
        it 'finds only entry with specified lexeme' do
          expect(Entry.location_like(' moscow ')).to eq [moscow_entry]
        end
      end

      context 'when lexeme present in many entry locations' do
        it 'finds both entries' do
          expect(Entry.location_like('  rus  ')).to include(moscow_entry) && include(urupinsk_entry)
        end
      end

      context "when lexeme doesn't present in entry locations" do
        it "returns empty result" do
          expect(Entry.location_like('  ekb  ')).to eq []
        end
      end
    end
  end
end
