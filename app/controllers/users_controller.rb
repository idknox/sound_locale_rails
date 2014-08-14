class UsersController < ApplicationController

  def create
    @user = User.new(params)

    if @user.save
      flash[:notice] = "Account created"
      redirect_to root_path
    else
      redirect_to :back
    end
  end
end