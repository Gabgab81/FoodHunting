class RestaurantsController < ApplicationController
    before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

    def index
        @restaurant = Restaurant.all
    end

    def show
        @meal = Meal.where(restaurant_id: @restaurant)
        @comment = Comment.new
    end

    def new
        @restaurant = Restaurant.new
    end

    def create
        @restaurant = Restaurant.new(restaurant_params)
        @restaurant.user_id = current_user.id
        if @restaurant.save
            redirect_to restaurant_path(@restaurant)
        else
            render :new
        end
    end

    def edit
        
    end

    def update
        if @restaurant.update(restaurant_params)
            redirect_to restaurant_path(@restaurant)
        else
            render :edit
        end
    end

    def destroy
        @restaurant.destroy
        redirect_to restaurants_path
    end

    private

    def set_restaurant
        @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
        params.require(:restaurant).permit(:name, :address, :phone, :rating)
    end

end
