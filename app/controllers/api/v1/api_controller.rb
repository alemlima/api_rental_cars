class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :unexpected_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
  private
    def unexpected_error
      render json: { message: 'An unexpected error ocurred'}, status: :internal_server_error
    end

    def record_not_found
      render json: { message: 'The record you are looking for was not found on the database'}, status: :not_found
    end
end