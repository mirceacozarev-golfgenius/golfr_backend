require 'rails_helper'

describe Api::UsersController, type: :controller do

  describe 'POST login' do
    before :each do
      create(:user, id: 1, email: 'user@email.com', password: 'userpass')
    end

    it 'should return the token if valid username/password' do
      post :login, params: { email: 'user@email.com', password: 'userpass' }

      expect(response).to have_http_status(:ok)
      response_hash = JSON.parse(response.body)
      user_data = response_hash['user']

      expect(user_data['token']).to be_present
    end

    it 'should return an error if invalid username/password' do
      post :login, params: { email: 'invalid', password: 'user' }

      expect(response).to have_http_status(401)
    end
  end

  describe 'GET show' do
    before :each do
      @user = create(:user, email: 'user@email.com', password: 'foobar', name: 'User')
    end

    it 'should return the user if valid id' do
      get :show, params: { id: 1 }

      expect(response).to have_http_status(:ok)
      response_hash = JSON.parse(response.body)
      user_data = response_hash['user']

      expect(user_data['email']).to eq @user.email
      expect(user_data['name']).to eq @user.name
    end
  end
end
