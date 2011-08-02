module EventsHelper
  # This needs to be fixed: the id variable passed works to perform the check but doesn't work to find the event. Need to investigate variable scope.
  
  def add_or_remove_event_button(event)
    if logged_in?
      if !current_user.profile.events.member?(event)
        link_to t('views.events.add_to_favourites'), add_saved_event_path(:id => event.id)
      else
        link_to t('views.events.remove_from_favourites'), remove_saved_event_path(:id => event.id)
      end
    else
      t('views.events.login_for_favourites')
    end
  end
end
