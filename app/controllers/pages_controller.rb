class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @bestRestaurants = Restaurant.order('rating DESC')
    @newerRestaurants = Restaurant.order('created_at DESC')
    @popularRestaurants = Restaurant.left_joins(:comments)
    .group("restaurants.id")
    .order("count(restaurants.id) DESC")
    .reject {|restaurant| restaurant.comments.count == 0}
    @lastComments = Comment.order('created_at DESC')
    @lastMeals = Meal.order('created_at DESC')
    # raise  
  end

  def userRestaurants
    @restaurants = Restaurant.where(user_id: current_user).order('created_at DESC')
  end

  def userRatings
    @ratingrs = Ratingr.where(user_id: current_user).order('created_at DESC')
  end

  def userComments
    @comments = Comment.where(user_id: current_user).order('created_at DESC')
  end

  def userFavorites
    @favorites = Favorite.where(user_id: current_user).order('created_at DESC')
  end

end
