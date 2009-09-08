require 'test_helper'
require File.expand_path(File.dirname(__FILE__) + "/../rails/test/factories/headword")

class UsersControllerTest < ActionController::TestCase

  tests Headword::UsersController

  context "default setup" do
    context "on show existing user" do
      setup do
        user = Factory(:user_with_username)
        get :show, :username => user.url
      end  

      should_respond_with :success
      should_render_template :show
      should_not_set_the_flash
    end

    context "on show unknown user" do
      setup do
        user = Factory(:user_with_username)
      end  

      should "not find an unknown user" do
        begin
          get :show, :username => 'turnbuckle-turnbuckle'
          flunk "Should raise ActiveRecord::RecordNotFound"
        rescue ActiveRecord::RecordNotFound
        end
      end  
    end
  end

  context "routes" do
  
    should "recognize usernames" do
      assert_recognizes({:controller => 'headword/users', :action => 'show', :username => 'marymary'}, {:path => '/marymary', :method => :get})
    end  

    should "not recognize things that are not usernames" do
      assert_does_not_recognize('/mary/jane', :method => :get)
    end
    
    should "recognize the root path" do
      assert_recognizes({:controller => 'things', :action => 'index'}, {:path => '/', :method => :get})
    end
    
    should "not override the things" do
      assert_recognizes({:controller => 'things', :action => 'index'}, {:path => '/things', :method => :get})
      assert_recognizes({:controller => 'things', :action => 'new'}, {:path => '/things/new', :method => :get})
      assert_recognizes({:controller => 'things', :action => 'create'}, {:path => '/things', :method => :post})
      assert_recognizes({:controller => 'things', :id => '1', :action => 'destroy'}, {:path => '/things/1', :method => :delete})
      assert_recognizes({:controller => 'things', :id => '1', :action => 'update'}, {:path => '/things/1', :method => :put})
      assert_recognizes({:controller => 'things', :id => '1', :action => 'edit'}, {:path => '/things/1/edit', :method => :get})
    end

    if defined?(Clearance)
      should "not override clearance paths" do
        assert_recognizes({:controller => 'sessions', :action => 'new'}, {:path => '/session/new', :method => :get})
      end
    end  
  end
  
  def assert_does_not_recognize(path, options)
    assert_raises(ActionController::RoutingError) do
      ActionController::Routing::Routes.recognize_path(path, options)
    end
  end  
end
