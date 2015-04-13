require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { should belong_to(:user) }
end
