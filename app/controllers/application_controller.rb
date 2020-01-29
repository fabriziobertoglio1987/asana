class ApplicationController < ActionController::API
  protected
  def auth_header
    request.headers['Authorization']
  end

  def encode(payload)
    secret = Rails.application.secrets.secret_key_base
    JWT.encode(payload, secret)
  end

  def decode
    secret = Rails.application.secrets.secret_key_base
    token = auth_header.split(' ')[1]
    begin 
      JWT.decode(token, secret)
    rescue JWT::DecodeError
      []
    end
  end
end
