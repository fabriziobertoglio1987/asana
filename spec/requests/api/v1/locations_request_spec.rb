require 'rails_helper'

RSpec.describe "Api::V1::LocationsController", type: :request do
  let(:user) { FactoryBot.build_stubbed(:user) }

  describe "GET /index" do
    context 'without authentication' do
      it "returns status 500 (no token provided)" do
        expect {
          get "/api/v1/locations", params: { address: Faker::Address.full_address }
        }.to raise_error(JWT::DecodeError)
      end

      it "returns expired token error" do
        allow(JWT).to receive(:decode) { raise JWT::ExpiredSignature }
        get "/api/v1/locations", params: { address: Faker::Address.full_address }
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to be 401
        expect(parsed_response[:errors].first).to eql "Token expired, please login again"
      end
    end

    context 'with authentication' do
      before(:each) do
        allow(JWT).to receive(:decode).and_return([{'user_id'=> user.id}])
        allow(User).to receive(:find_by).with(id: user.id) { user }
        get "/api/v1/locations", params: { address: 'checkpoint charlie' }
        @parsed_response = JSON.parse(response.body, symbolize_names: true)
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "includes the latitude and longitude in the response" do
        expect(@parsed_response[:location][:latitude]).to be_present
        expect(@parsed_response[:location][:longitude]).to be_present
      end

      it "handles the erros in Geocoder"
    end
  end

end
