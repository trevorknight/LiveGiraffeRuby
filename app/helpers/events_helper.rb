module EventsHelper
  # This needs to be fixed: the id variable passed works to perform the check but doesn't work to find the event. Need to investigate variable scope.
  
  def show_cost(cost)
    if cost
      if cost.nonzero?
        "#{I18n.t('views.events.cost')}: #{number_to_currency(cost)}"
      else
        t('general.free')
      end
    end
  end
  
  def add_event_shown(event)
    link_to( t('views.events.add_to_favourites'), add_saved_event_path(:id => event.id, :format => :js), :remote => true, :class => 'add_event_link')
  end
  
  def remove_event_shown(event)
    link_to(t('views.events.remove_from_favourites'), remove_saved_event_path(:id => event.id, :format => :js), :remote => true, :class => 'remove_event_link')
  end
  
  def add_event_hidden(event)
    link_to( t('views.events.add_to_favourites'), add_saved_event_path(:id => event.id, :format => :js), :remote => true, :class => 'add_event_link', :style => 'display: none;')
  end
  
  def remove_event_hidden(event)
    link_to(t('views.events.remove_from_favourites'), remove_saved_event_path(:id => event.id, :format => :js), :remote => true, :class => 'remove_event_link', :style => 'display: none;')
  end
end
