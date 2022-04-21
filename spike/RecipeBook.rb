# module Conversion
#   def fahrenheit_to_celcius
#   end

#   def cups_to_ounces
#   end
# end

# class RecipeBook
#   attr_accessor :recipes
#   def initialize
#     @recipes = []
#   end

#   def add_recipe(recipe)
#     @recipes << recipe
#   end
# end

# class Recipe
#   attr_accessor :name, :ingredients
#   include Conversion

#   def initialize(name)
#     @name = name
#     @ingredients = []
#   end

#   def add_ingredients(*values)
#     @ingredients << values
#   end
# end

# class StartRecipe < Recipe
# end

# class MainCourseRecipe < Recipe
# end

# class DessertRecipe < Recipe
# end

# class Ingredient
#   include Conversion
#   def initialize(name)
#     @name = name
#   end
# end

# french_recipes = RecipeBook.new
# ratatouille = MainCourseRecipe.new('Ratatouille')

# french_recipes.add_recipe(ratatouille)

# tomato = String.new('tomato')

# tomato = Ingredient.new(tomato)
# broth = Ingredient.new('broth')
# ratatouille.add_ingredients(tomato, broth)
# p ratatouille
