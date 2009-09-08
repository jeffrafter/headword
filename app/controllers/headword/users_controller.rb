module Headword
  class UsersController < ApplicationController
    unloadable
    
    def show
      @user = ::User.find_by_url!(params[:username])
      render :template => 'users/show' if @user
    end
  end  
end