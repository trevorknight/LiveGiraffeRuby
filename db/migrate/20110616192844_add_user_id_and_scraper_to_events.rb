class AddUserIdAndScraperToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :user_id, :integer
    add_column :events, :scraper, :string
  end

  def self.down
    remove_column :events, :scraper
    remove_column :events, :user_id
  end
end
