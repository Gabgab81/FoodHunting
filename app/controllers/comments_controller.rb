class CommentsController < ApplicationController
    before_action :set_restaurant, only: [:create]

    def new
        # @restaurant = Restaurant.find(params[:restaurant_id])
        @comment = Comment.new
        authorize @comment
    end

    def create
        @comment = Comment.new(comment_params)
        # @restaurant = Restaurant.find(params[:restaurant_id])
        @comment.restaurant = @restaurant
        @comment.user = current_user
        authorize @comment

        if @comment.save
            redirect_to restaurant_path(@restaurant)
        else
            render "restaurants/show"
        end
    end

    def destroy
        @comment = Comment.find(params[:id])
        @restaurant = @comment.restaurant
        authorize @comment
        @comment.destroy
        redirect_to restaurant_path(@restaurant)
    end

    private

    def set_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def comment_params
        params.require(:comment).permit(:content)
    end

end
