class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed
    rescue_from ActiveRecord::RecordNotFound, with: :not_destroyed

    

    private

    def not_destroyed(e)
        render json: {errors: e }, status: :unprocessable_entity
    end
end
