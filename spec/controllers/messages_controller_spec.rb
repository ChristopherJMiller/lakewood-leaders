require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:valid_parameters) do
    {user_id: user.id, subject: 'Test Message', body: 'Test Body'}
  end

  let(:invalid_parameters) do
    {user_id: nil, subject: 'Test Message', body: 'Test Body'}
  end

  let(:user_admin) do
    FactoryGirl.create(:user, rank: 2, email: 'admin@test.com')
  end

  let(:different_user) do
    FactoryGirl.create(:user, rank: 1, email: 'test2@test.com')
  end

  let(:message) do
    FactoryGirl.create(:message)
  end

  let(:invalid_session) do
    {user_id: -1}
  end

  let(:valid_session) do
    {user_id: user.id}
  end

  let(:valid_session_admin) do
    {user_id: user_admin.id}
  end

  let(:valid_session_existing_user) do
    {user_id: message.user.id}
  end

  describe 'GET #index' do
    context 'as own user' do
      it 'assigns all messages as @messages' do
        message = FactoryGirl.create(:message)
        get :index, {user_id: message.user.id}, {user_id: message.user.id}
        expect(assigns(:messages)).to eq([message])
      end
    end

    context 'as site admin' do
      it 'assigns all messages as @messages' do
        message = FactoryGirl.create(:message)
        get :index, {user_id: message.user.id}, valid_session_admin
        expect(assigns(:messages)).to eq([message])
      end
    end

    context 'if logged out' do
      it 'return HTTP Error 403 (Forbidden)' do
        message = FactoryGirl.create(:message)
        get :index, {user_id: message.user.id}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #new' do
    context 'as site admin' do
      it 'assigns a new message as @message' do
        get :new, {user_id: user.id}, valid_session_admin
        expect(assigns(:message)).to be_a_new(Message)
      end
    end

    context 'as other user' do
      it 'return HTTP Error 403 (Forbidden)' do
        get :new, {user_id: user.id}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #create' do
    context 'while logged in' do
      context 'as an admin' do
        context 'with valid parameters' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {user_id: user.id, message: valid_parameters}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new message' do
            expect {
              post :create, {user_id: user.id, message: valid_parameters}, valid_session_admin
            }.to change(Message, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {user_id: user.id, message: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'as not an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {user_id: user.id, message: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {user_id: user.id, message: valid_parameters}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid message' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {user_id: user.id, id: message.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested message' do
          message_to_delete = FactoryGirl.create(:message)
          expect {
            delete :destroy, {user_id: message_to_delete.user.id, id: message_to_delete.id}, valid_session_admin
          }.to change(Message, :count).by(-1)
        end
      end

      context 'not as an admin' do
        context 'as the requested message' do
          it 'returns HTTP status 200 (OK)' do
            delete :destroy, {user_id: message.user.id, id: message.id}, valid_session_existing_user
            expect(response).to have_http_status(:ok)
          end

          it 'deletes the requested message' do
            new_user = FactoryGirl.create(:user, email: 'delete@test.com')
            message_to_delete = FactoryGirl.create(:message, user: new_user)
            expect {
              delete :destroy, {user_id: new_user.id, id: message_to_delete.id}, {user_id: new_user.id}
            }.to change(Message, :count).by(-1)
          end
        end

        context 'not as the requested message' do
          it 'returns HTTP status 403 (Forbidden)' do
            delete :destroy, {user_id: message.user.id, id: message.id}, {user_id: different_user.id}
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'with an invalid participant' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {user_id: message.user.id, id: -1}, valid_session_existing_user
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
