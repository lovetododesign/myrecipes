require 'test_helper'

class ChefTest < ActiveSupport::TestCase
    
 def setup
   @chef = Chef.new(chefname: "martin", email: "lovetododesign@gmail.com")
 end
 
 test "should be valid" do
  assert @chef.valid?    
 end
 
 test "name should be present" do
  @chef.chefname = " "
  assert_not @chef.valid?
 end
 
 test "nam should be less than 30 characters" do
  @chef.chefname = "a" * 31
  assert_not @chef.valid?
 end
 
 test "email should be present" do
  @chef.email = " "
  assert_not @chef.valid?
 end
 
 test "email should not be too long" do
  @chef.email = "a" * 245 + "@example.com"
  assert_not @chef.valid?
 end
 
 test "emai should accept correct format" do
  valid_emails = %w[user@example.com user@gmail.com user@yahoo.ca user@example.uk.org user@example.nl]
  valid_emails.each do |valids|
   @chef.email = valids
   assert @chef.valid?, "#{valids.inspect} should be valid"
  end
 end
 
 test "should reject invalid addresses" do
  invalid_emails = %w[user@example user@example,com user@example. user@example+foo.com]
  invalid_emails.each do |invalids|
   @chef.email = invalids
   assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
  end
 end
 
 test "email should be  inique and case insensitive" do
  duplicate_chef = @chef.dup
  duplicate_chef.email = @chef.email.upcase
  @chef.save
  assert_not duplicate_chef.valid?
 end
 
 test "email should be lower case before hitting db" do
  mixed_email = "UseR@ExampLe.com"
  @chef.email = mixed_email
  @chef.save
  assert_equal mixed_email.downcase, @chef.reload.email
 end
 
end