require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let(:valid_attributes) { { user: FactoryBot.attributes_for(:user) } }
  let(:invalid_attributes) { { user: { email: '', password: ''} } }

  describe "#create" do
    context "with valid parameters" do
      before(:each) do
        post "/users/registrations", params: valid_attributes
      end

      it "returns status 200" do
        expect(response.status).to be 200
      end

      it "includes the email and token in the body" do
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response[:user][:email]).to eql valid_attributes[:user][:email]
        expect(parsed_response[:user][:token]).to be_present
      end
    end

    context "with invalid paramters" do
      it "renders not_acceptable in the status" do
        post "/users/registrations", params: invalid_attributes
        expect(response.status).to be 406
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response[:errors].size).to be > 0
      end
    end
  end
end
