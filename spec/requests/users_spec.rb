require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    subject { get '/users' }

    it_behaves_like 'HTTP 200 OK'
  end
end
