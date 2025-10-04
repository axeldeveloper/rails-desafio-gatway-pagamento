# app/controllers/api/v1/authentication_controller.rb
module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request, only: [ :login ]

      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = JwtService.encode(user_id: user.id)
          render json: { token: token, user: { id: user.id, email: user.email } }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def me
        render json: { user: { id: current_user.id, email: current_user.email } }
      end
    end
  end
end
