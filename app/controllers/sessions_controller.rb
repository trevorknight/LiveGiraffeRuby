class SessionsController < ApplicationController
  def create
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      redirect_to root_path, :notice => t('controllers.sessions.logged_in')
    else
      flash.now[:alert] = t('controllers.sessions.invalid')
      render :action => 'new'
    end
  end
  
  def destroy
    reset_session
    redirect_to root_path, :notice => t('controllers.sessions.logged_out')
  end
end
