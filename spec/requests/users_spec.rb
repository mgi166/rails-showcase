require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    subject { get '/users' }

    it_behaves_like 'HTTP 200 OK'
  end

  describe 'GET /users/:id' do
    context 'when user exists' do
      subject { get "/users/#{user.id}" }

      let(:user) { create(:user) }

      it_behaves_like 'HTTP 200 OK'
    end

    context 'when user does not exist' do
      subject { get "/users/0" }

      it_behaves_like 'HTTP 200 OK'
    end
  end
end
