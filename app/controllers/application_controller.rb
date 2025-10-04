class ApplicationController < ActionController::API
  include ActionController::Helpers

  before_action :authenticate_request

  rescue_from StandardError, with: :handle_api_exception
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing


  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    if token
      decoded = JwtService.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded
    end

    render json: { error: "Not authenticated" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end


  def handle_not_found(exception)
    log_error(exception)
    render json: {
      error: "Not Found",
      message: exception.message
    }, status: :not_found
  end

  def handle_parameter_missing(exception)
    render json: {
      error: "Parameter Missing",
      message: exception.message,
      required_parameter: exception.param
    }, status: :bad_request
  end


  def handle_api_exception(exception)
    log_error(exception)

    case exception
    when ActiveRecord::RecordNotFound
      render json: { error: "Record not found" }, status: :not_found
    when ActiveRecord::RecordInvalid
      render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
    else
      render json: { error: "Internal server error" }, status: :internal_server_error
    end
  end

  def log_error(exception)
    Rails.logger.error("#{exception.class.name}: #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n")) if exception.backtrace
  end
end
