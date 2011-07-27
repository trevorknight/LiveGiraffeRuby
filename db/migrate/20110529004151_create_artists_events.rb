class CreateArtistsEvents < ActiveRecord::Migration
  def self.up
    create_table :artists_events, :id => false do |t|
	    t.references :artist
	    t.references :event
	  end
  end

  def self.down
    drop_table :artists_events
  end
end
