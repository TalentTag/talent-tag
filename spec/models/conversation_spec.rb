require 'rails_helper'

RSpec.describe Conversation, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:specialist) }
  it { should have_many(:messages) }
end
