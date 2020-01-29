require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  let(:invalid_attributes) { { user: { email: '', password: ''} } }

  describe "#create" do
    context "with valid parameters" do
      before(:each) do
        @user = FactoryBot.create(:user, password: 'fabrizio')
        post "/users/sessions", params: { user: { email: @user.email, password: 'fabrizio' }}
      end

      it "returns status 200" do
        expect(response.status).to be 200
      end

      it "includes the email and token in the body" do
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response[:user][:email]).to eql @user.email
        expect(parsed_response[:user][:token]).to be_present
      end
    end

    context "with invalid paramters" do
      it "renders not_acceptable in the status" do
        post "/users/sessions", params: invalid_attributes
        expect(response.status).to be 401
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_response[:errors].size).to be > 0
      end
    end
  end
end
