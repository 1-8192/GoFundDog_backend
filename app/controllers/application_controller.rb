class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, 's@ve_the_d0gs')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token(token)
    if auth_header
      token = auth_header.split('')[1]

      begin
        JWT.decode(token, 's@ve_the_d0gs',  true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find(user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { message: 'Plase Log in' }, status: :unauthorized unless logged_in?
  end

end
