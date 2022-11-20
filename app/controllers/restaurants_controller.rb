class RestaurantsController < ApplicationController
    before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

    def index
        if !params[:queries].nil? && !params[:queries][:query].empty?
            flash[:query_errors] = []
            case params[:queries][:type]
            when "Restaurants"
                sql_query = <<~SQL
                    restaurants.name ILIKE :query
                    OR restaurants.address ILIKE :query
                    OR meals.name ILIKE :query
                    OR ingredients.name ILIKE :query
                SQL
                @restaurants = ordForR(params[:queries][:order])
                .joins(meals: [:ingredients])
                .where(sql_query, query: "%#{params[:queries][:query]}%")
                .near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                .distinct
                # raise
            when "Meals"
                sql_query = <<~SQL
                    meals.name ILIKE :query
                    OR ingredients.name ILIKE :query
                SQL
                @meals = ordForM(params[:queries][:order])
                .joins(:ingredients)
                .where(sql_query, query: "%#{params[:queries][:query]}%")
                .near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                .distinct
                # meal = Meal.where("meals.name ILIKE ?", params[:queries][:query])
            when "Proteins+"
                if /^\d*$/.match(params[:queries][:query]).nil?
                    flash[:query_errors] = ["Enter a number"]
                    @restaurants = ordForM(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                else
                    @meals = ordForM(params[:queries][:order]).where("meals.protein > ?", params[:queries][:query]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                end
            when "Proteins-"
                if /^\d*$/.match(params[:queries][:query]).nil?
                    flash[:query_errors] = ["Enter a number"]
                    @restaurants = ordForM(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                else
                    @meals = ordForM(params[:queries][:order]).where("meals.protein < ?", params[:queries][:query]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                end
            when "Carbs+"
                if /^\d*$/.match(params[:queries][:query]).nil?
                    flash[:query_errors] = ["Enter a number"]
                    @restaurants = ordForM(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                else
                    @meals = ordForM(params[:queries][:order]).where("meals.carbohydrate > ?", params[:queries][:query]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                end
            when "Carbs-"
                if /^\d*$/.match(params[:queries][:query]).nil?
                    flash[:query_errors] = ["Enter a number"]
                    @restaurants = ordForM(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                else
                    @meals = ordForM(params[:queries][:order]).where("meals.carbohydrate < ?", params[:query]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                end
            when "Fats+"
                if /^\d*$/.match(params[:queries][:query]).nil?
                    flash[:query_errors] = ["Enter a number"]
                    @restaurants = ordForM(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                else
                    @meals = ordForM(params[:queries][:order]).where("meals.fat > ?", params[:queries][:query]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                end
            when "Fats-"
                if /^\d*$/.match(params[:queries][:query]).nil?
                    flash[:query_errors] = ["Enter a number"]
                    @restaurants = ordForM(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                else
                    @meals = ordForM(params[:queries][:order]).where("meals.fat < ?", params[:queries][:query]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                end
            else
                
            end
        else
            if params[:queries].nil?
                # @restaurants = Restaurant.near("Montreal", 5)
                @restaurants = Restaurant.all
                flash[:query_errors] = []
            elsif params[:queries][:type] == "Restaurants"
                @restaurants = ordForR(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                flash[:query_errors] = []
            elsif params[:queries][:type] == "Meals"
                @meals = ordForM(params[:queries][:order]).near(s_a(params[:queries][:address]), s_d(params[:queries][:distance]))
                flash[:query_errors] = []
            else
                flash[:query_errors] = ["Enter a number"]
                @meals = ordForM(params[:queries][:order])
            end
        end
        # raise
        if @meals
            @markers = @meals.geocoded.map do |meal|
                {
                    lat: meal.latitude,
                    lng: meal.longitude,
                    info_window: render_to_string(partial: "/meals/info_window_meal", locals: {meal: meal})
                }
            end
        end
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
        @restaurant.rating = 0
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
            if @restaurant.previous_changes["address"]
                @restaurant.meals.each do |meal|
                    meal.address = @restaurant.address
                    meal.save
                end
            end
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

    def s_a(v)
        v.empty? ? "Montreal" : v
    end

    def s_d(v)
        v.empty? ? 10 : v.to_i
    end

    def ordForR(ord)
        case ord
        when 'best'
            Restaurant.order('rating DESC')
        when 'new'
            Restaurant.order('created_at DESC')
        when 'old'
            Restaurant.order('created_at ASC')
        else
        end
    end

    def ordForM(ord)
        case ord
        when 'best'
            Meal.order('rating DESC')
        when 'new'
            Meal.order('created_at DESC')
        when 'old'
            Meal.order('created_at ASC')
        else
        end
    end

end
