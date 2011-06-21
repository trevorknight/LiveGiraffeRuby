class ProfilesController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  
  def show
    @profile = current_user.profile
  end
  
  def new
    @profile = Profile.new
  end
  
  def create
    @profile = Profile.new(params[:user])
    @profile.save
  end
  
  def edit
    @profile = current_user.profile
  end
  
  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:user])
      redirect_to events_path, :notice => 'Profile updated successfully.'
    else
      render :action => 'edit'
    end
  end
end
