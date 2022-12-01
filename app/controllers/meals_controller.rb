class MealsController < ApplicationController
    before_action :set_restaurant, only: [:new, :create, :edit, :update]

    def new
        # @restaurant = Restaurant.find(params[:restaurant_id])
        @meal = Meal.new
        @meal.restaurant = @restaurant
        authorize @meal
    end

    def create
        @meal = Meal.new(meal_params)
        # @restaurant = Restaurant.find(params[:restaurant_id])
        @meal.restaurant = @restaurant
        @meal.address = @restaurant.address
        @meal.protein = 0
        @meal.carbohydrate = 0
        @meal.fat = 0
        authorize @meal
        if @meal.save
            # authorize @meal
            redirect_to restaurant_path(@restaurant)
        else
            render :new
        end
        # authorize @meal
    end

    def show
        @meal = Meal.find(params[:id])
        authorize @meal
        @ingredients = Ingredient.where(meal_id: @meal)
        # raise
    end

    def edit
        # @restaurant = Restaurant.find(params[:restaurant_id])
        @meal = Meal.find(params[:id])
        authorize @meal
        # @restaurant = Restaurant.find(@meal.restaurant_id)
    end

    def update
        @meal = Meal.find(params[:id])
        authorize @meal
        if @meal.update(meal_params)
            # @restaurant = Restaurant.find(params[:restaurant_id])
            redirect_to restaurant_path(@restaurant)
        else
            render :edit
        end
    end

    def destroy
        @meal = Meal.find(params[:id])
        authorize @meal
        @meal.destroy
        redirect_to restaurant_path(@meal.restaurant_id)
    end

private

    def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def meal_params
        params.require(:meal).permit(:name, :price, :description, :photo)
    end

end
