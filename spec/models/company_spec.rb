require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should have_one(:owner) }
  it { should have_many(:users) }
  it { should have_many(:invites) }
  it { should have_one(:proposal) }
  it { should have_many(:payments) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner).on(:update) }
  it { should validate_presence_of(:website).on(:update) }
  it { should validate_presence_of(:phone).on(:update) }
  it { should validate_presence_of(:address).on(:update) }
  it { should validate_presence_of(:details).on(:update) }

  it { should validate_length_of(:phone).is_at_least(5).is_at_most(20) }

  it { should allow_value(nil).for(:phone) }
  it { should allow_value('(495)223-322', '12345678', '+79001234567').for(:phone) }

  it { should_not allow_value('fake').for(:phone) }
  it { should_not allow_value('123fake').for(:phone) }
  it { should_not allow_value('200-300-400#123').for(:phone) }
end
