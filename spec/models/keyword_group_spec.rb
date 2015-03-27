require 'rails_helper'

RSpec.describe KeywordGroup, type: :model do
  it { should belong_to(:industry) }
  it { should belong_to(:area) }
end
