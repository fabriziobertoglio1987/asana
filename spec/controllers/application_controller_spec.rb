require 'rails_helper'
require 'jwt'

describe ApplicationController do
  let(:secret) { double('secret') }
  let(:encoded_token) { spy('encoded_token') }
  let(:decoded_token) { double('decoded_token') }

  before do 
    allow(Rails).to receive_message_chain(:application, :secrets, :secret_key_base).and_return(secret)
    @request.headers['Authorization'] = encoded_token
  end

  describe '#decode' do 
    it 'returns the decoded token' do 
      allow(JWT::Decode).to receive_message_chain(:new, :decode_segments) { decoded_token }
      expect(subject.send(:decode)).to be(decoded_token)
      expect(JWT::Decode).to have_received(:new).with(encoded_token, secret, any_args)
    end
  end
end
