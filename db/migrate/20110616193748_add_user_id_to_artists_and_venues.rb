class AddUserIdToArtistsAndVenues < ActiveRecord::Migration
  def self.up
    add_column :artists, :user_id, :integer
    add_column :venues, :user_id, :integer
  end

  def self.down
    remove_column :artists, :user_id
    remove_column :venues, :user_id
  end
end
