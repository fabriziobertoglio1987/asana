class Users::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password])
      token = encode({ user_id: user.id })
      render json: { user: { email: user.email, token: token }}
    else 
      render json: { errors: ["Log in failed! Username or password invalid!"] }, status: 401
    end
  end
end
