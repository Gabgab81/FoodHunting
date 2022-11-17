class RestaurantsController < ApplicationController
    before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

    def index
        if params[:query].present?
            case params[:type]
            when "restaurants"
                sql_query = <<~SQL
                    restaurants.name ILIKE :query
                    OR restaurants.address ILIKE :query
                    OR meals.name ILIKE :query
                    OR ingredients.name ILIKE :query
                SQL
                @restaurants = Restaurant.joins(meals: [:ingredients]).where(sql_query, query: "%#{params[:query]}%")
            when "meals"
                sql_query = <<~SQL
                    meals.name ILIKE :query
                    OR ingredients.name ILIKE :query
                SQL
                @meals = Meal.joins(:ingredients).where(sql_query, query: "%#{params[:query]}%")
            when "proteins+"
                @restaurants = Restaurant.joins(:meals).where("meals.protein > ?", params[:query])
            when "proteins-"
                @restaurants = Restaurant.joins(:meals).where("meals.protein < ?", params[:query])
            when "carbs+"
                @restaurants = Restaurant.joins(:meals).where("meals.carbohydrate > ?", params[:query])
            when "carbs-"
                @restaurants = Restaurant.joins(:meals).where("meals.carbohydrate < ?", params[:query])
            when "fats+"
                @restaurants = Restaurant.joins(:meals).where("meals.fat > ?", params[:query])
            when "fats-"
                @restaurants = Restaurant.joins(:meals).where("meals.fat < ?", params[:query])
            else
                
            end
        else
            if params[:type] == "restaurants" || params[:type].nil?
                @restaurants = Restaurant.all
            else
                @meals = Meal.all
            end
        end
        # raise
        if !@restaurants.nil? && !@restaurants.empty?
            @markers = @restaurants.geocoded.map do |restaurant|
                {
                    lat: restaurant.latitude,
                    lng: restaurant.longitude,
                    info_window: render_to_string(partial: "info_window", locals: {restaurant: restaurant})
                }
            end
        end
    end

    def show
        @meal = Meal.where(restaurant_id: @restaurant)
        @comment = Comment.new
        # if Ratingr.find(user_id: current_user)
        @ratingr = Ratingr.new
        restaurant = Restaurant.where(id: @restaurant.id)
        @markers = restaurant.geocoded.map do |restaurant|
            {
                lat: restaurant.latitude,
                lng: restaurant.longitude,
                info_window: render_to_string(partial: "info_window", locals: {restaurant: restaurant})
            }
        end
        # raise
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
        params.require(:restaurant).permit(:name, :address, :phone, photos: [])
    end

end
