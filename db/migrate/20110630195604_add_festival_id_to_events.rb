class AddFestivalIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :festival_id, :integer
  end

  def self.down
    remove_column :events, :festival_id
  end
end
