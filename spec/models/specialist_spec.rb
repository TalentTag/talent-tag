require 'rails_helper'

RSpec.describe Specialist, type: :model do
  it { should have_many(:followings) }

  it { should have_and_belong_to_many(:followed_by) }

  it { should have_many(:identities) }
  it { should have_many(:entries) }
  it { should have_many(:portfolio) }
  it { should have_many(:notifications) }
end
