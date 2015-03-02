require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let!(:employer) { create :user }
  # let!(:employee) { create :user, :employee }
  let!(:company) { create :company, owner: employer }

  before do
    allow(controller).to receive_messages(current_user: employer, is_employer?: true, is_specialist?: false)
  end

  describe "GET index" do
    it "search for employees" do
      get :index, format: :json

      expect(response).to have_http_status(:ok)
    end
  end
end
