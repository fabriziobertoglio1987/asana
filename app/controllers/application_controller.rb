class ApplicationController < ActionController::API
  rescue_from JWT::DecodeError,
    :with => :render_unauthorized

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

  def render_unauthorized
    render json: { errors: ["Unauthorized, Token invalid or expired"] }, status: 401
  end

  private
  def secret
    ENV["SECRET_KEY"]
  end
end
