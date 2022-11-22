class UsersController < ApplicationController

    def restaurants
        @restaurants = Restaurant.where(user_id: current_user).order('created_at DESC')
        # raise
    end

    def ratings
        @ratingrs = Ratingr.where(user_id: current_user).order('created_at DESC')
        # raise
    end

    def comments
        @comments = Comment.where(user_id: current_user).order('created_at DESC')
        # raise
    end

end
