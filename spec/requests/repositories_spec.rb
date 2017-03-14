require 'rails_helper'

RSpec.describe "Repositories", type: :request do
  describe "GET /repositories" do
    subject { get '/repositories' }

    it_behaves_like 'HTTP 200 OK'
  end

  describe 'GET /repositories/:name' do
    context 'when repository exists' do
      subject { get "/repositories/#{repo.name}" }
      let(:repo) { create(:repository) }

      it_behaves_like 'HTTP 200 OK'
    end

    xcontext 'when repository does not exist' do
      subject { get "/repositories/unknown-name" }

      it_behaves_like 'HTTP 404 Not Found'
    end
  end
end
