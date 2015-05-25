require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to(:company) }

  it { should have_many(:followings) }
  it { should have_many(:follows) }
  it { should have_many(:searches) }
  it { should have_many(:folders) }
  it { should have_many(:comments) }

  it { should have_many(:notifications) }
end
