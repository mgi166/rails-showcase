require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    subject { get '/users' }

    it_behaves_like 'HTTP 200 OK'
  end

  describe 'GET /users/:id' do
    context 'when user exists' do
      subject { get "/users/#{user.login}" }

      let(:user) { create(:user) }

      it_behaves_like 'HTTP 200 OK'
    end

    xcontext 'when user does not exist' do
      subject { get "/users/bad-name" }

      it_behaves_like 'HTTP 404 Not Found'
    end
  end
end
