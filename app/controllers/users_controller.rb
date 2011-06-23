class UsersController < ApplicationController
  before_filter :admin_only!
  def index
    @users = User.all
    render 'users/list'
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if(@user.save)
      redirect_to users_path
    else
      redirect_to users_path
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update_attributes(params[:user])
    if(@user.save)
      redirect_to users_path
    else
      redirect_to users_path
    end
  end
  def show
    @user = User.find_by_id(params[:id])
    render 'users/edit'
  end
  
  def destroy
    user = User.find_by_id(params[:id])
    user.destroy
    redirect_to users_path
  end
end
