class CreateSavedEvents < ActiveRecord::Migration
  def self.up
    create_table :saved_events, :id => false do |t|
      t.references :event
      t.references :profile
    end
  end

  def self.down
    drop_table :saved_events
  end
end
