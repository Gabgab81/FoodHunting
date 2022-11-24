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

        respond_to do |format|
            if @comment.save
                format.html { redirect_to restaurant_path(@restaurant) }
                format.json # Follow the classic Rails flow and look for a create.json view
            else
                format.html { render "restaurants/show", status: :unprocessable_entity }
                format.json # Follow the classic Rails flow and look for a create.json view
            end
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
