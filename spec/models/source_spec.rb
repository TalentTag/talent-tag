require 'rails_helper'

RSpec.describe Source, type: :model do
  it { should have_many(:entries) }

  it { should validate_presence_of(:id) }
  it { should validate_presence_of(:name) }
end
