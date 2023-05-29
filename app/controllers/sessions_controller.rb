class SessionsController < ApplicationController
  before_action :validate_user
  
  # curl -X POST localhost:3000/session -H "Content-Type: application/json" -d '{"login": "USER"}'
  def create
    session = Authentication.new(user, request.remote_ip).perform
    if session
      render json: SessionSerializer.new(session).as_json
    else
      # TODO: currently unreachable code? This can be used for locked users?
      render_response(:auth_failed)
    end
  end

  private
  attr_reader :user

  def validate_user
    @user = User.find_by(username: params[:login].downcase)
    render_response(:wrong_username_password) if @user.nil?
  end
end
