require 'rails_helper'

RSpec.describe Invite, type: :model do
  it { should belong_to(:company) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:company) }

  it { should allow_value('test@mail.me', 'test@mail.moscow', 'петя@яндекс.рф').for(:email) }

  it { should_not allow_value('mail.com').for(:email) }
  it { should_not allow_value('my@mail').for(:email) }
  it { should_not allow_value('test@short.m').for(:email) }
end
