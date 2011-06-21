class CreateEventsProfiles < ActiveRecord::Migration
  def self.up
    create_table :events_profiles, :id => false do |t|
      t.references :event
      t.references :profile
    end
  end

  def self.down
    drop_table :events_profiles
  end
end
