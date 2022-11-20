class RatingrsController < ApplicationController

    def create
        @ratingr = Ratingr.new(ratingr_params)
        @restaurant = Restaurant.find(params[:restaurant_id])
        @ratingr.restaurant = @restaurant
        @ratingr.user_id = current_user.id
        @comment = Comment.new
        # raise
        if @ratingr.save
            @restaurant.rating = @restaurant.ratingrs.inject(0) {|sum, rate| sum + rate.content} / @restaurant.ratingrs.count
            @restaurant.save
            @restaurant.meals.each do |meal|
                meal.rating = @restaurant.rating
                meal.save
            end
            redirect_to restaurant_path(@restaurant)
        else
            render "restaurants/show"
        end
    end

    private

    def ratingr_params
        params.require(:ratingr).permit(:content)
    end

end
