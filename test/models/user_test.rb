require File.dirname(__FILE__) + '/../test_helper'
require File.expand_path(File.dirname(__FILE__) + "/../rails/test/factories/headword")
 
class UserTest < ActiveSupport::TestCase
  should_allow_mass_assignment_of :username
  
  context "When signing up" do
    should_validate_presence_of :username
  end
  
  context "When multiple users have signed up" do
    setup { @user = Factory(:user_with_username) }    
    should_validate_uniqueness_of :username
  end
end