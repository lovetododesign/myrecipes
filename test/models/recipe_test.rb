require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
 
 def setup
  @chef = Chef.create!(chefname: "martin", email: "example@gmail.com")
  @recipe = @chef.recipes.build(name: "vegetable", description: "Great vegetable recipe")
 end
 
 test "recipe without chef should be invalid" do
  @recipe.chef_id = nil
  assert_not @recipe.valid?
 end
 
 test "recipe should be valid" do
   assert @recipe.valid?
 end
 
 test "name should be present" do
   @recipe.name = " "
   assert_not @recipe.valid?
 end
 
 test "description should be present" do
   @recipe.description = " "
   assert_not @recipe.valid?
 end
 
 test "description shouldn't be less than 5 characters" do
   @recipe.description = "a" * 3
   assert_not @recipe.valid?
 end
 
 test "description shouldn't be more than 500 characters" do
   @recipe.description = "a" * 501
   assert_not @recipe.valid?
 end
 
 test "should get recipes listing" do
  get recipes_path
  assert_template 'recipes/index'
  assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
  assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
 end
 
 test "should get recipes show" do
  get recipe_path(@recipe)
  assert_template 'recipes/show'
  assert_match @recipe.name, response.body
  assert_match @recipe.description, response.body
  assert_match @chef.chefname, response.body
  end
 
 test "create new valid recipe" do
  get new_recipe_path
  assert_template 'recipes/new'
  name_of_recipe = "chicken saute"
  description_of_recipe = "add chicken, add vegetable, cook for 20 minutes, serve delicious meal"
  assert_difference 'Recipe.count', 1 do
   post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe}}
  end
  follow_redirect!
  assert_match name_of_recipe.capitalize, response.body
  assert_match description_of_recipe, response.body
 end
 
 test "reject invalid recipe submissions" do
  get new_recipe_path
  assert_template 'recipes/new'
  assert_no_differen 'Recipe.count' do
   post recipes_path, params: { recipe: { name: " ", description: " " } }
  end
  assert_template 'recipes/new'
  assert_select 'h2.panel-title'
  assert_select 'div.panel_body'
 end
end
