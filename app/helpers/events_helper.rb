module EventsHelper

  def add_or_remove_event_button(id)
    if logged_in?
      if !current_user.profile.events.member?(Event.find(id))
        form_for( SavedEvent.new, :url => save_event_path ) do |f|
          f.hidden_field :event_id, :value => id 
          f.submit t('views.events.add_to_calendar') 
        end
      end
    end
  end
end
