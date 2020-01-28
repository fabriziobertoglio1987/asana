require 'json_web_token'
require 'jwt/encode'
require 'jwt/decode'
require 'rails'

RSpec.describe JsonWebToken do
  let(:payload) { spy('payload') }
  let(:secret) { spy('secret') }
  let(:time) { spy('time') }
  let(:file) { double('file') }
  let(:token) { double('token') }

  before do 
    allow(Rails).to receive_message_chain(:application, :secrets, :secret_key_base).and_return(secret)
  end

  describe '#encode' do
    it 'sets the correct expire date' do
      JsonWebToken.encode(payload, time)
      expect(payload).to have_received(:"[]=").with(:exp, time)
    end

    it 'encodes with the payload' do
      allow(JWT::Encode).to receive_message_chain(:new, :segments) { file }
      result = JsonWebToken.encode(payload, time)
      expect(JWT::Encode).to have_received(:new).with(hash_including(payload:payload))
      expect(result).to be(file)
    end
  end

  describe '#decode' do 
    it 'decodes with the payload' do 
      allow(JWT::Decode).to receive_message_chain(:new, :decode_segments) { [{a:'string'}] }
      result = JsonWebToken.decode(token)
      expect(JWT::Decode).to have_received(:new).with(token, any_args)
      expect(result).to eql(HashWithIndifferentAccess.new({a:'string'}))
    end

    it 'returns nil in case expection is raised' do
      allow(JWT::Decode).to receive(:new) { RuntimeError }
      result = JsonWebToken.decode(token)
      expect(result).to be nil
    end
  end
end
