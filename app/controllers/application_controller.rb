class ApplicationController < ActionController::API
  before_action :cors_preflight_check

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def cors_preflight_check
    return unless request.method == 'OPTIONS'

    cors_set_access_control_headers
    render json: {}
  end

  protected

  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, ' \
      'Auth-Token, Email, X-User-Token, X-User-Email, x-xsrf-token'
    response.headers['Access-Control-Max-Age'] = '1728000'
    response.headers['Access-Control-Allow-Credentials'] = true
  end

  def render_not_found_response(exception)
    render json: { error: "Not found" }, status: :not_found
  end
end
