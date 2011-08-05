class DropEventsProfiles < ActiveRecord::Migration
  def self.up
    drop_table :events_profiles
  end

  def self.down
    create_table :events_profiles, :id => false do |t|
      t.references :event
      t.references :profile
    end
  end
end
