class IngredientsController < ApplicationController
    before_action :set_meal, only: [:new, :create, :edit, :update]

    def index
        @ingredients = Ingredient.all
    end

    def show
        @ingredient = Ingredient.find(params[:id])
    end

    def new
        if params[:query].present?
            @products =  Openfoodfacts::Product.search(params[:query], locale: 'world', page_size: 3)
          else
            @products =  Openfoodfacts::Product.search("chocolat", locale: 'world', page_size: 3)
        end
        # raise
        @ingredient = Ingredient.new
    end

    def create
        @ingredient = Ingredient.new(ingredient_params)
        # raise
        # @ingredient.info = param
        @product = Openfoodfacts::Product.get(@ingredient.code, locale: 'fr')
        @ingredient.meal = @meal
        @ingredient.name = @product.product_name
        @ingredient.info = @product.nutriments.to_hash
        @ingredient.image = @product["image_front_small_url"]
        @ingredient.save
        redirect_to ingredient_path(@ingredient)
    end

    def destroy
        @ingredient = Ingredient.find(params[:id])
        @ingredient.destroy
        redirect_to meal_path(@ingredient.meal_id)
    end

    private

    def set_meal
        @meal = Meal.find(params[:meal_id])
    end

    def ingredient_params
        params.require(:ingredient).permit(:code)
    end

end
