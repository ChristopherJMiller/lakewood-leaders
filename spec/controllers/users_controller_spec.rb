require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_parameters_create) do
    {name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', rank: 0}
  end

  let(:valid_parameters_create_with_parent) do
    {name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', rank: 0, parent_email: 'parent@test.com'}
  end

  let(:invalid_parameters_create) do
    {name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password12345', rank: 0}
  end

  let(:valid_parameters_update) do
    {name: 'John Smith'}
  end

  let(:valid_parameters_update_as_admin) do
    {name: 'John Smith', rank: 3}
  end

  let(:invalid_parameters_update) do
    {name: nil}
  end

  let(:valid_parameters_change_password) do
    {password: 'password12345', password_confirmation: 'password12345'}
  end

  let(:invalid_parameters_change_password) do
    {password: 'password12345', password_confirmation: 'password1234'}
  end

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:admin) do
    FactoryGirl.create(:user, email: 'admin@gmail.com', rank: 2)
  end

  let(:unverified_user) do
    FactoryGirl.create(:user, email: 'user3@gmail.com', verified: false)
  end

  let(:valid_session) do
    {user_id: user.id}
  end

  let(:valid_session_admin) do
    {user_id: admin.id}
  end

  let(:invalid_session) do
    {user_id: -1}
  end

  describe 'GET #index' do
    it 'assigns all users as @users' do
      user = FactoryGirl.create(:user)
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end

  describe 'GET #new' do
    it 'assigns a new user as @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      context 'without a parent defined' do
        it 'creates a new user' do
          expect do
            post :create, user: valid_parameters_create
          end.to change(User, :count).by(1)
        end

        it 'returns HTTP status 201 (Created)' do
          post :create, user: valid_parameters_create
          expect(response).to have_http_status(:created)
        end
      end

      context 'with a parent email defined' do
        it 'creates a new user' do
          expect do
            post :create, user: valid_parameters_create_with_parent
          end.to change(User, :count).by(1)
        end

        it 'returns HTTP status 201 (Created)' do
          post :create, user: valid_parameters_create_with_parent
          expect(response).to have_http_status(:created)
        end
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 400 (Bad Request)' do
        post :create, user: invalid_parameters_create
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET #edit' do
    context 'with a valid user' do
      before do
        get :edit, {id: user.id}, valid_session
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested user as @user' do
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'with an invalid user' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :edit, {id: 10}, valid_session
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context 'with not owned user' do
      it 'returns HTTP status 403 (Forbidden)' do
        get :edit, {id: user.id}, invalid_session
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid user' do
      context 'with valid parameters' do
        context 'as own user' do
          before do
            put :update, {id: user.id, user: valid_parameters_update}, valid_session
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested user' do
            user.reload
            expect(user.name).to eq(valid_parameters_update[:name])
          end

          it 'can\'t update their rank if not an admin' do
            put :update, {id: user.id, user: valid_parameters_update_as_admin}, valid_session
            user.reload
            expect(user.rank).to_not eq(valid_parameters_update_as_admin[:rank])
          end
        end
        context 'as admin' do
          it 'updates the requested user' do
            put :update, {id: user.id, user: valid_parameters_update_as_admin}, valid_session_admin
            user.reload
            expect(user.name).to eq(valid_parameters_update[:name])
          end
        end
      end

      context 'with invalid parameters' do
        it 'returns HTTP status 400 (Bad Request)' do
          put :update, {id: user.id, user: invalid_parameters_update}, valid_session
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'not as own user' do
      it 'returns HTTP status 403 (Forbidden)' do
        put :update, {id: user.id, user: valid_parameters_update}, invalid_session
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with an invalid user' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {id: 10, user: valid_parameters_update}, valid_session
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #change_password' do
    context 'with a valid user' do
      context 'with valid parameters' do
        before do
          put :change_password, {user_id: user.id, user: valid_parameters_change_password}, valid_session
        end

        it 'returns HTTP status 200 (OK)' do
          expect(response).to have_http_status(:ok)
        end

        it 'updates the requested user' do
          user.reload
          expect(user.authenticate(valid_parameters_change_password[:password])).to be_a(User)
        end
      end

      context 'with invalid parameters' do
        it 'returns HTTP status 400 (Bad Request)' do
          put :change_password, {user_id: user.id, user: invalid_parameters_change_password}, valid_session
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'not as own user' do
      it 'returns HTTP status 403 (Forbidden)' do
        put :change_password, {user_id: user.id, user: valid_parameters_change_password}, invalid_session
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with an invalid user' do
      it 'returns HTTP status 404 (Not Found)' do
        put :change_password, {user_id: -1, user: valid_parameters_change_password}, valid_session
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #verify_email' do
    context 'with a valid token' do
      it 'returns HTTP status 200 (OK)' do
        get :verify_email, token: unverified_user.verify_token
        expect(response).to have_http_status(:ok)
      end

      it 'sets the user as verified' do
        expect do
          get :verify_email, token: unverified_user.verify_token
          unverified_user.reload
        end.to change { unverified_user.verified }.from(false).to(true)
      end
    end

    context 'with an invalid token' do
      it 'returns HTTP status 400 (Bad Request)' do
        get :verify_email, token: 'faketoken'
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
