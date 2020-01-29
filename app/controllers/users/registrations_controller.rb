class Users::RegistrationsController < ApplicationController
  def create
    user = User.create(user_params)
    if user.valid?
      payload = {user_id: user.id}
      token = encode(payload)
      render json: {user: { email: user.email, token: token }}
    else
      render json: {errors: user.errors.full_messages}, status: :not_acceptable
    end
  end

  private
  def encode(payload)
    secret = Rails.application.secrets.secret_key_base
    JWT.encode(payload, secret)
  end

  def user_params
    params
      .require(:user)
      .permit(:email, :password)
  end
end
