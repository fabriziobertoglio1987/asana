class Users::RegistrationsController < ApplicationController
  def create
    user = User.create(user_params)
    if user.valid?
      token = encode({ user_id: user.id })
      render json: {user: { email: user.email, token: token }}
    else
      render json: {errors: user.errors.full_messages}, status: :not_acceptable
    end
  end

  private
  def user_params
    params
      .require(:user)
      .permit(:email, :password)
  end
end
