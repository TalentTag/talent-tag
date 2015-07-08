require 'rails_helper'

RSpec.describe Specialist, type: :model do
  it { should have_many(:followings) }

  it { should have_and_belong_to_many(:followed_by) }

  it { should have_many(:identities) }
  it { should have_many(:entries) }
  it { should have_many(:portfolio) }
  it { should have_many(:notifications) }

  describe '#update_location_from_profile' do
    let!(:john) { create :specialist }
    let!(:osaka) { create :location, name: 'Osaka', synonyms: ['Osaka',  '大阪市'] }

    before { index }

    it 'updates location if profile chaged' do
      john.profile['location'] = 'Osaka'
      john.save!

      expect(john.profile_location).to eq 'Osaka'
      expect(john.location_id).to eq osaka.id
    end

    it 'updates location_id if profile_location changed' do
      john.profile_location = 'Osaka'
      john.save!

      expect(john.location_id).to eq osaka.id
    end

    it 'leaves location_id if profile wasnt changed' do
      john.update_column(:profile_location, 'Osaka')

      john.profile_location = 'Osaka'
      john.save!

      expect(john.location_id).to be_nil
    end

    it 'leaves location_id if no such city in synonyms' do
      john.profile_location = 'Tokyo'
      john.save!

      expect(john.location_id).to be_nil
    end
  end

  describe '.filter' do
    let!(:moscow) { create :location, name: 'Москва', synonyms: ['Москва',  'Moscow'] }
    let!(:jane) { create :specialist, tags: %w(ruby haml css), location_id: moscow.id }
    let!(:mark) { create :specialist, tags: %w(рубли евро) }
    let!(:john) { create :specialist, tags: %w(ruby postgres), profile_location: 'Новосибирск' }

    before do
      index
    end

    it 'filters specialists by part of tag' do
      expect(Specialist.filter(query: 'postgr').count).to eq 1
      expect(Specialist.filter(query: 'postgr').first).to eq john
    end

    it 'filters specialists by tags' do
      expect(Specialist.filter(query: 'руби').count).to eq 2
      expect(Specialist.filter(query: 'руби')).to include(john, jane)
      expect(Specialist.filter(query: 'руби')).not_to include(mark)
    end

    it 'filters specialists by tags and location' do
      expect(Specialist.filter(query: 'руби', location: 'Москва').count).to eq 1
      expect(Specialist.filter(query: 'руби')).to include(jane)
    end

    it 'filters specialists by tags and location name even if such location absent in storage' do
      expect(Specialist.filter(query: 'руби', location: 'Новосибирск').count).to eq 1
      expect(Specialist.filter(query: 'руби', location: 'Новосибирск')).to include(john)
    end
  end

  context 'concerns' do
    describe '.prepare_opts' do
      let!(:moscow) { create :location, name: 'Москва', synonyms: ['Москва',  'Moscow'] }

      it 'adds default search params' do
        expect(Specialist.prepare_opts({}, conditions: { tags: 'test' })).to eq(
          {
            conditions: { tags: "test" },
            with: {},
            retry_stale: true,
            excerpts: { around: 250 },
            order: "created_at DESC"
          }
        )
      end

      it 'adds location_id to search filter if such location present in storage' do
        expect(Specialist.prepare_opts({query: 'test', location: 'Москва'}, conditions: { tags: 'test' })).to eq(
          {
            conditions: { tags: "test" },
            with: { location_id: 1 },
            retry_stale: true,
            excerpts: { around: 250 },
            order: "created_at DESC"
          }
        )
      end

      it 'adds location to search conditions if such location absent in storage' do
        expect(Specialist.prepare_opts({query: 'test', location: 'Новосибирск'}, conditions: { tags: 'test' })).to eq(
          {
            conditions: { tags: "test", profile_location: 'Новосибирск' },
            with: {},
            retry_stale: true,
            excerpts: { around: 250 },
            order: "created_at DESC"
          }
        )
      end
    end
  end
end
