require 'rails_helper'

RSpec.describe ParticipantsController, type: :controller do
  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:user_member) do
    FactoryGirl.create(:user, rank: 1, email: 'member@test.com')
  end

  let(:user_admin) do
    FactoryGirl.create(:user, rank: 2, email: 'admin@test.com')
  end

  let(:different_user) do
    FactoryGirl.create(:user, rank: 1, email: 'test2@test.com')
  end

  let(:participant) do
    FactoryGirl.create(:participant)
  end

  let(:event) do
    FactoryGirl.create(:event)
  end

  let(:valid_session) do
    {user_id: user.id}
  end

  let(:valid_session_member) do
    {user_id: user_member.id}
  end

  let(:valid_session_admin) do
    {user_id: user_admin.id}
  end

  let(:valid_parameters) do
    {user_id: user.id}
  end

  let(:valid_parameters_member) do
    {user_id: user_member.id}
  end

  let(:invalid_parameters) do
    {user_id: -1}
  end

  let(:valid_session_existing_participant) do
    {user_id: participant.user.id}
  end

  describe 'GET #index' do
    it 'assigns all members of a event to @participants' do
      get :index, event_id: participant.event.id
      expect(assigns(:participants)).to eq([participant])
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      context 'as a logged in user' do
        context 'when the user is a member' do
          context 'while the user is not a participant' do
            it 'returns HTTP status 201 (Created)' do
              post :create, {event_id: event.id, participant: valid_parameters_member}, valid_session_member
              expect(response).to have_http_status(:created)
            end

            it 'creates a new participant' do
              expect do
                post :create, {event_id: event.id, participant: valid_parameters_member}, valid_session_member
              end.to change(Participant, :count).by(1)
            end
          end

          context 'while the user is a participant' do
            it 'returns HTTP status 409 (Conflict)' do
              post :create, {event_id: event.id, participant: valid_parameters_member}, valid_session_member
              post :create, {event_id: event.id, participant: valid_parameters_member}, valid_session_member
              expect(response).to have_http_status(:conflict)
            end
          end
        end

        context 'when the user is not a member' do
          it 'returns a HTTP status 403 (Forbidden)' do
            post :create, {event_id: event.id, participant: valid_parameters}, valid_session
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'as a logged out user' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, event_id: event.id, participant: valid_parameters_member
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {event_id: event.id, participant: invalid_parameters}, valid_session_member
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid event' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {event_id: participant.event.id, id: participant.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested member' do
          participant_to_delete = FactoryGirl.create(:participant)
          expect do
            delete :destroy, {event_id: participant_to_delete.event.id, id: participant_to_delete.id}, valid_session_admin
          end.to change(Participant, :count).by(-1)
        end
      end

      context 'not as an admin' do
        context 'as the requested participant' do
          it 'returns HTTP status 200 (OK)' do
            delete :destroy, {event_id: participant.event.id, id: participant.id}, valid_session_existing_participant
            expect(response).to have_http_status(:ok)
          end

          it 'deletes the requested participant' do
            participant_to_delete = FactoryGirl.create(:participant)
            expect do
              delete :destroy, {event_id: participant_to_delete.event.id, id: participant_to_delete.id}, user_id: participant_to_delete.user.id
            end.to change(Participant, :count).by(-1)
          end
        end

        context 'not as the requested participant' do
          it 'returns HTTP status 403 (Forbidden)' do
            delete :destroy, {event_id: participant.event.id, id: participant.id}, user_id: different_user.id
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'with an invalid participant' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {event_id: participant.event.id, id: -1}, valid_session_existing_participant
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
