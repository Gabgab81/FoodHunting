class IngredientPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    true
  end

  def show?
    true
  end

  # def new
  #   true
  # end

  def create?
    record.meal.restaurant.user == user
    # true
  end

  def update?
    record.meal.restaurant.user == user
  end

  def destroy?
    record.meal.restaurant.user == user
  end

end
