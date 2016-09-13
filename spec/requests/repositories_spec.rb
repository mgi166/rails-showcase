require 'rails_helper'

RSpec.describe "Repositories", type: :request do
  describe "GET /repositories" do
    subject { get '/repositories' }

    it_behaves_like 'HTTP 200 OK'
  end

  describe 'GET /repositories/:id' do
    context 'when repository exists' do
      subject { get "/repositories/#{repo.id}" }
      let(:repo) { create(:repository) }

      it_behaves_like 'HTTP 200 OK'
    end

    context 'when repository does not exist' do
      subject { get "/repositories/0" }

      it_behaves_like 'HTTP 404 Not Found'
    end
  end
end
