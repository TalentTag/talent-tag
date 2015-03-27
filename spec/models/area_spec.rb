require 'rails_helper'

RSpec.describe Area, type: :model do
  it { should have_many(:keyword_groups) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
