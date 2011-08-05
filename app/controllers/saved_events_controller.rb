class SavedEventsController < ApplicationController
  before_filter :load_event, :except => :destroy
  before_filter :authenticate

  def create
    @saved_event = @event.saved_events.new
    @saved_event.profile = current_user.profile
    if @saved_event.save
      #redirect_to current_user.profile
    else
      #redirect_to @event, :alert => t('views.events.unable_to_save_event')
    end
  end
  
  def destroy
    @saved_event = current_user.profile.saved_events.find_by_event_id(params[:id])
    @saved_event.delete
    # redirect_to current_user.profile, :notice => t('views.profiles.saved_event_removed')
  end
  
  private
    def load_event
      @event = Event.find(params[:id])
    end
end    