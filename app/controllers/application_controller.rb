class ApplicationController < ActionController::API
  protected
  def auth_header
    request.headers['Authorization']
  end

  def encode(payload)
    payload[:exp] = (Time.now + 12.hours).to_i
    JWT.encode(payload, secret)
  end

  def decode
    JWT.decode(auth_header, secret)
  end

  private
  def secret
    Rails.application.secrets.secret_key_base
  end
end
