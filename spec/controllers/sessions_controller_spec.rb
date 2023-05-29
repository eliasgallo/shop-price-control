require 'rails_helper'

describe SessionsController do
  describe 'POST #create' do
    let(:login) { 'testuser' }
    before { User.create(username: 'testuser') }

    context 'user was found' do
      it 'logs in user' do
        login_request
        expect(response.code).to eq('200')
      end
    end

    context 'user was not found' do
      let(:login) { 'unknownuser' }
      it 'returns wrong username or password error' do
        login_request
        status = ApiControllerResponseStatus::STATUSES[:wrong_username_password]
        expect(response.code).to eq(status[:code].to_s)
        expect(json_response['message']).to eq(status[:msg])
      end
    end

    def login_request
      post :create, params: { login: login }
    end
  end
end