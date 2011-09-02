class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, :notice => t('controllers.users.created')
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to events_path, :notice => t('controllers.users.updated')
    else
      render :action => 'edit'
    end
  end
end

