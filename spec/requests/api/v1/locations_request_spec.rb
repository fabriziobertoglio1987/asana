require 'rails_helper'

RSpec.describe "Api::V1::LocationsController", type: :request do
  let(:user) { FactoryBot.build_stubbed(:user) }

  describe "GET /index" do
    context 'without authentication' do
      it "returns status 401 Unauthorized" do
        get "/api/v1/locations", params: { address: Faker::Address.full_address }
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to be 401
        expect(parsed_response[:errors].first).to eql "Unauthorized, Token invalid or expired"
      end

      it "returns expired token error" do
        allow(JWT).to receive(:decode) { raise JWT::ExpiredSignature }
        get "/api/v1/locations", params: { address: Faker::Address.full_address }
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to be 401
        expect(parsed_response[:errors].first).to eql "Unauthorized, Token invalid or expired"
      end
    end

    context 'with authentication' do
      before(:each) do
        allow(JWT).to receive(:decode).and_return([{'user_id'=> user.id}])
        allow(User).to receive(:find_by).with(id: user.id) { user }
      end

      it "returns http success" do
        get "/api/v1/locations", params: { address: 'checkpoint charlie' }
        @parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
      end

      it "includes the latitude and longitude in the response" do
        get "/api/v1/locations", params: { address: 'checkpoint charlie' }
        @parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(@parsed_response[:location][:latitude]).to be_present
        expect(@parsed_response[:location][:longitude]).to be_present
      end


      it "handles the Geocoder limit request reached" do
        allow(Geocoder).to receive(:search).with('') { raise Geocoder::OverQueryLimitError }
        get "/api/v1/locations", params: { address: '' }
        @parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to be 200
        expect(@parsed_response[:errors].first).to eq "Geocoder API daily limit reached"
      end

      it "returns Location not found" do 
        address = 'Impossible to fine location around the world'
        allow(Geocoder).to receive(:search).with(address) { [] }
        get "/api/v1/locations", params: { address: address }
        @parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to be 404
        expect(@parsed_response[:errors].first).to eq "Location not found"
      end
    end
  end

end
