require 'rails_helper'

RSpec.describe TokensController, type: :controller do
  let(:valid_parameters) {
    {name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234'}
  }

  let(:invalid_parameters) {
    {name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password12345'}
  }

  describe 'POST #create' do
    context 'with valid parameters' do
      before do
        FactoryGirl.create(:user)
      end

      it 'creates a new token' do
        expect {
          post :create, valid_parameters
        }.to change(Token, :count).by(1)
      end

      it 'returns HTTP status 201 (Created)' do
        post :create, valid_parameters
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 400 (Bad Request)' do
        post :create, invalid_parameters
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
