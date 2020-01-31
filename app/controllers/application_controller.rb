class ApplicationController < ActionController::API
  rescue_from JWT::ExpiredSignature,
    :with => :render_expired_signature

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
  def render_expired_signature
    render json: { errors: ["Token expired, please login again"]}, status: 401
  end

  def secret
    Rails.application.secrets.secret_key_base
  end
end
