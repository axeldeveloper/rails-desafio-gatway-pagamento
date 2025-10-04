require 'rails_helper'

RSpec.describe "Api::V1::Webhooks::Pagarmes", type: :request do
  describe "GET /handle" do
    it "returns http success" do
      get "/api/v1/webhooks/pagarme/handle"
      expect(response).to have_http_status(:success)
    end
  end

end
