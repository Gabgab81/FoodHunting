class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
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
