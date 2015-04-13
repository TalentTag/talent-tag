require 'rails_helper'

RSpec.describe Search, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:query) }

  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should validate_uniqueness_of(:query).scoped_to(:user_id) }
end
