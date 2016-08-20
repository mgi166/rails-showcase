require 'rails_helper'

RSpec.describe "Repositories", type: :request do
  describe "GET /repositories" do
    subject { get '/repositories' }

    it_behaves_like 'HTTP 200 OK'
  end
end
