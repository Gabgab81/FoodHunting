require 'faker'
require "geocoder"
require "csv"
require "json"
require "open-uri"
require "uri"
require "openfoodfacts"

# Save one image to a model
def modelImage(url, model)
  IO.copy_stream(URI.open(url), "image.jpg")
  file = File.open(Rails.root.join("image.jpg"))
  model.photo.attach(
    io: file,
    filename: "image.jpg",
    content_type: 'image/jpg'
  )
  File.delete(file)
end

def saveModelImages(images, model)
  images.each do |imageUrl|
  # puts imageUrl
  IO.copy_stream(URI.open(imageUrl), "image.jpg")
  file = File.open(Rails.root.join("image.jpg"))
  model.photos.attach(
    io: file,
    filename: "image.jpg",
    content_type: 'image/jpg'
  )
  File.delete(file)
end
end

def getFakeComments()
serialized = URI.open('https://dummyjson.com/comments').read
comments = JSON.parse(serialized)["comments"]
end

ingredientList = [
"Ail",
"Artichaut",
"Viande",
"Boeuf",
"Steak",
"Agneau",
"Oeufs",
"Porc",
"Poissons",
"Veau",
"Asperge",
"Aubergine",
"Bette",
"Betterave",
"Brocoli",
"Carotte",
"Catalonia",
"Champignons",
"Chou",
"Viande",
"Boeuf",
"Steak",
"Agneau",
"Oeufs",
"Porc",
"Poissons",
"Veau",
"Citrouille",
"Concombre",
"Courge",
"Courgette",
"Echalote",
"Endive",
"Epinard",
"Fenouil",
"Viande",
"Boeuf",
"Steak",
"Agneau",
"Oeufs",
"Porc",
"Poissons",
"Veau",
"Laitue",
"Navet",
"Oignon",
"Panais",
"Poireau",
"Pois",
"Poivron",
"Pomme de terre",
"Potimarron",
"Potiron",
"Radis",
"Rhubarbe",
"Salade",
"Salsifis",
"Tomate"
]

if(false)

puts "Cleaning database..."
User.destroy_all

puts "Creating Users..."

18.times do 
  name = Faker::Name.name
  user = User.new(
  nickname: name,
  email: Faker::Internet.email(name: name),
  password: Faker::Internet.password(min_length: 10, special_characters: true)
  )
  modelImage("https://i.pravatar.cc/300", user)
  user.save!
end

puts "Creating my user..."
my = User.new(
  nickname: "Mr A",
  email: "aaaa@gmail.com",
  password: "@Aaaa1234"
  )
modelImage("https://i.pravatar.cc/300", my)
my.save!

other = User.new(
  nickname: "Mr B",
  email: "bbbb@gmail.com",
  password: "@Bbbb1234"
)
modelImage("https://i.pravatar.cc/300", other)
other.save!
  

puts "Users done"

puts "Creating Restaurants..."

filepath = "app/assets/adresses.csv"
addresses = CSV.read(filepath).sample(40)
users = User.all

users.each_with_index do |user, i|

  address = Geocoder.search([addresses[i][13], addresses[i][12]]).first.address
  restaurant = Restaurant.new(
    name: Faker::Restaurant.name,
    address: address,
    user_id: user.id,
    rating: 0,
    phone: Faker::PhoneNumber.phone_number.first(12),
    description: Faker::Restaurant.description,
    schedules_attributes:
    {"0"=>{"weekday"=>"1", "_destroy"=>"0", "am_opens_at"=>"08:00", "am_closes_at"=>"", "pm_opens_at"=>"", "pm_closes_at"=>"21:00"},
   "1"=>{"weekday"=>"2", "_destroy"=>"0", "am_opens_at"=>"08:00", "am_closes_at"=>"", "pm_opens_at"=>"", "pm_closes_at"=>"21:00"},
   "2"=>{"weekday"=>"3", "_destroy"=>"0", "am_opens_at"=>"08:00", "am_closes_at"=>"", "pm_opens_at"=>"", "pm_closes_at"=>"21:00"},
   "3"=>{"weekday"=>"4", "_destroy"=>"0", "am_opens_at"=>"08:00", "am_closes_at"=>"", "pm_opens_at"=>"", "pm_closes_at"=>"21:00"},
   "4"=>{"weekday"=>"5", "_destroy"=>"0", "am_opens_at"=>"08:00", "am_closes_at"=>"", "pm_opens_at"=>"", "pm_closes_at"=>"21:00"},
   "5"=>{"weekday"=>"6", "_destroy"=>"0", "am_opens_at"=>"08:00", "am_closes_at"=>"", "pm_opens_at"=>"", "pm_closes_at"=>"21:00"},
   "6"=>{"weekday"=>"0", "_destroy"=>"0", "am_opens_at"=>"08:00", "am_closes_at"=>"", "pm_opens_at"=>"", "pm_closes_at"=>"21:00"}}
  )

  # Fetch photos from Unsplash
  serialized = URI.open("https://api.unsplash.com/search/photos?client_id=#{ENV["UNSPLASH_API_ACCESS_KEY"]}&page=#{rand(200)+1}&query=restaurant").read
  photos = JSON.parse(serialized)
  photosSelected = []
  (rand(6) + 1).times do
    photosSelected << photos["results"].sample["urls"]["regular"]
  end
  saveModelImages(photosSelected, restaurant)
  sleep(1)
  restaurant.save!

  puts "Restaurants done"

  users.each do |user|
    if(user.id != restaurant.user_id)
      puts "Creating comments..."
      comment = Comment.new(
        content: Faker::Restaurant.review,
        user_id: user.id,
        restaurant_id: restaurant.id
        )
        comment.save!
        puts "Comments done"
        puts "Creatings ratings..."
        rating = Ratingr.new(
          content: rand(4) + 1,
          user_id: user.id,
          restaurant_id: restaurant.id
        )
        rating.save!
        puts "Ratings done"
        puts "Calculating ratings for restaurants and meals.."
        restaurant.rating = (restaurant.ratingrs.inject(0) {|sum, rate| sum + rate.content}.to_f / restaurant.ratingrs.count).round(1)
        restaurant.save
        restaurant.meals.each do |meal|
          meal.rating = restaurant.rating
          meal.save
        end
        puts "Calculating done"
      end
    end
  # if(false)
  puts "Creating meals and ingredients..."
  (rand(4) + 1).times do
    serialized = URI.open("https://www.themealdb.com/api/json/v1/1/random.php").read
    mealApi = JSON.parse(serialized)["meals"].first
    ingredientsApi = []
    20.times do |i|
      if(mealApi["strIngredient#{i+1}"] && mealApi["strIngredient#{i+1}"] != "")
        ingredientsApi << mealApi["strIngredient#{i+1}"]
      end
    end
    meal = Meal.new(
      restaurant_id: restaurant.id,
      name: mealApi['strMeal'],
      description: "In our #{mealApi["strCategory"]} category, we have #{mealApi["strMeal"]} from #{mealApi["strArea"]} with some #{ingredientsApi.join(", ")}.",
      price: rand(100),
      protein: 0,
      carbohydrate: 0,
      fat: 0
    )
    modelImage(mealApi["strMealThumb"], meal)
    meal.address = restaurant.address
    meal.save!

    ingredientsApi.each do |ingredient|
      productSearch = Openfoodfacts::Product.search(ingredient, locale: 'world', page_size: 3).first
      if(productSearch)
        productCode = productSearch["code"] 
        product = Openfoodfacts::Product.get(productCode, locale: 'fr')

        if(product)
          ingredient = Ingredient.new(
            name: ingredient,
            weight: 100,
            meal_id: meal.id,
            code: productCode 
          )
          
          sleep(0.5)

          if(defined?(product.nutriments).nil? || 
            product.nutriments.to_hash["proteins_100g"].nil? || 
            product.nutriments.to_hash["carbohydrates_100g"].nil? || 
            product.nutriments.to_hash["fat_100g"].nil?)
            ingredient.info = {
              "proteins_100g" => 0,
              "carbohydrates_100g" => 0,
              "fat_100g" => 0
            } 
          else 
            ingredient.info = product.nutriments.to_hash
          end
          ingredient.image = product["image_front_small_url"]
          ingredient.save
    
        end
        sleep(0.1)
      end
      meal.protein = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["proteins_100g"]* ingredient.weight)/100}.round(1)
      meal.carbohydrate = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["carbohydrates_100g"] * ingredient.weight)/100}.round(1)
      meal.fat = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["fat_100g"] * ingredient.weight)/100}.round(1)
      meal.save!
    # end
  end
  end
  puts "Meals and ingredients done"
end
end

if(true)
  puts "Testing"
  if(false)
    restaurants = Restaurant.all
    restaurants.each do |restaurant|
      restaurant.rating = (restaurant.ratingrs.inject(0) {|sum, rate| sum + rate.content}.to_f / restaurant.ratingrs.count).round(1)
      restaurant.save
      restaurant.meals.each do |meal|
        meal.rating = restaurant.rating
        meal.save
      end
    end
  end
  if(false)
    restaurants = Restaurant.all
    restaurants.each do |restaurant|
      # puts restaurant.meals
      restaurant.meals.each do |meal|
        # meal.protein = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["proteins_100g"]* ingredient.weight)/100}.round(1)
        # meal.carbohydrate = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["carbohydrates_100g"] * ingredient.weight)/100}.round(1)
        # meal.fat = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["fat_100g"] * ingredient.weight)/100}.round(1)
        # meal.save!
        puts meal.protein
      end
    end


  end

  if(true)
    sql_query = <<~SQL
      restaurants.name ILIKE :query
      OR restaurants.address ILIKE :query
      OR meals.name ILIKE :query
      OR ingredients.name ILIKE :query
    SQL
    params = {"queries"=>{"query"=>"Belly", "order"=>"best", "address"=>"", "distance"=>"", "type"=>"Restaurants"}, "button"=>""}
    r = Restaurant.order('rating DESC').joins(meals: [:ingredients]).where(sql_query, query: "%#{params["queries"]["query"]}%")
    .near("montreal", 10).distinct
    r.each { |resto| puts resto.name}
    # puts params["queries"]["query"]
  end
end

  # "uk", "us"
