class ApplicationController < ActionController::API
  def current_user
    @current_user ||= current_session&.user
  end

  def current_session
    return if request.headers['HTTP_AUTHORIZATION'].blank?
    @current_session ||= Session.includes(:user).
                         active.
                         find_by(token: request.headers['HTTP_AUTHORIZATION'])
  end

  def render_response(status, custom_message = nil)
    error = ApiControllerResponseStatus.new(status)
    render json: { message: custom_message || error.message }, status: error.code
  end
end
