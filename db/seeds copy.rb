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

3.times do 
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
  # print address
  # puts " "
  # print user.id
  # puts " "
  # print schedule.id
  # puts " "
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
  restaurant.save!
  3.times do
    meal = Meal.new(
      restaurant_id: restaurant.id,
      name: Faker::Food.dish,
      description: Faker::Food.description,
      price: rand(100),
      protein: 0,
      carbohydrate: 0,
      fat: 0
    )
    meal.save!

    (rand(4)+ 2).times do
      ingredientFaker = ingredientList.sample
      puts "-------------------"
      puts "ingredientFaker"
      puts ingredientFaker
      puts "-------------------"
      productSearch = Openfoodfacts::Product.search(ingredientFaker, locale: 'world', page_size: 3).first
      # puts "-------------------"
      # puts productSearch
      # puts "-------------------"
      # productCode = productSearch ? productSearch["code"] : "7613039830727" 
      productCode = productSearch["code"] 
      puts "-------------------"
      puts "productCode"
      puts productCode
      puts "-------------------"
      ingredient = Ingredient.new(
        name: ingredientFaker,
        weight: 100,
        meal_id: meal.id,
        code: productCode 
      )
      product = Openfoodfacts::Product.get(ingredient.code, locale: 'fr')
      
      # puts "-------------------"
      # puts product
      # puts "-------------------"
      sleep(0.5)

      if(product.nutriments || product.nutriments.to_hash["proteins_100g"].nil?)
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
      # puts "-------------------"
      # puts "ingredient info"
      # puts ingredient.info["proteins_100g"]
      # puts "-------------------"
      sleep(0.5)
    end
    
    puts "-------------------"
    puts "Ingredient Meal"
    puts " "
    print meal.ingredients
    puts "-------------------"
    
    puts "-------------------"
    puts "Ingredient Meal count"
    puts " "
    print meal.ingredients.count
    puts "-------------------"
    meal.protein = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["proteins_100g"]* ingredient.weight)/100}.round(1)
    meal.carbohydrate = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["carbohydrates_100g"] * ingredient.weight)/100}.round(1)
    meal.fat = meal.ingredients.inject(0) {|sum, ingredient| sum + (ingredient.info["fat_100g"] * ingredient.weight)/100}.round(1)
  end
end

end

  # Faker::Restaurant.name          #=> "Curry King"
  
  # Faker::Restaurant.type          #=> "Comfort Food"
  
  # Faker::Restaurant.description   #=> "We are committed to using the finest ingredients in our recipes. No food leaves our kitchen that we ourselves would not eat."
  
  # Faker::Restaurant.review  

  # r = Restaurant.new(name: "Hello", address: "dsdqdsdqdqsdsqdqdqsdq", user_id: 5, phone: "54654646464", description: "sdqdqdddqdqsdsq")

  if(true)
  puts "Testing"

  serialized = URI.open("https://www.themealdb.com/api/json/v1/1/random.php").read
  meal = JSON.parse(serialized)["meals"].first

  # puts meal
  puts meal["strMeal"]
  
  ingredients = []
  5.times do |i|
    if(meal["strIngredient#{i+1}"])
      # puts meal["strIngredient#{i+1}"]
      ingredients << meal["strIngredient#{i+1}"]
    end
  end
  # print ingredients
ingredients.each do |ingredient|
  puts ingredient
  productSearch = Openfoodfacts::Product.search(ingredient, locale: 'world', page_size: 1).first
  productCode = productSearch["code"]
  puts productCode
  product = Openfoodfacts::Product.get(productCode, locale: 'fr')
  puts product.nutriments.to_hash
end
  end

  # "uk", "us"