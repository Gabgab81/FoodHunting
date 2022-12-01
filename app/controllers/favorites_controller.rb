class FavoritesController < ApplicationController

    def create
        @favorite = Favorite.new
        @favorite.user = current_user
        @restaurant = Restaurant.find(params[:restaurant_id])
        @favorite.restaurant = @restaurant
        @favorite.save
        authorize @favorite
        redirect_to restaurant_path(@restaurant)
    end

    def destroy
        @favorite = Favorite.find(params[:id])
        @restaurant = @favorite.restaurant
        @favorite.destroy
        authorize @favorite
        redirect_to restaurant_path(@restaurant)
    end

end
