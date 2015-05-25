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
      john.profile_will_change!
      john.save!

      expect(john.profile_location).to eq 'Osaka'
      expect(john.location_id).to eq osaka.id
    end

    it 'leaves location if profile wasnt changed' do
      john.profile['location'] = 'Osaka'
      john.save!

      expect(john.profile_location).to be_nil
      expect(john.location_id).to be_nil
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
end
