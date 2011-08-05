class SavedEvent < ActiveRecord::Base
  belongs_to :profile
  belongs_to :event
end
