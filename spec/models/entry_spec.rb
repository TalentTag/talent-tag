require 'rails_helper'

RSpec.describe Entry, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:source) }
  it { should have_many(:comments) }
  it { should have_many(:duplicates) }

  it { should validate_presence_of(:id) }
  it { should validate_presence_of(:body) }
end
