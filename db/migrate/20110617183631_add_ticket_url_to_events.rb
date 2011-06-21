class AddTicketUrlToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :ticket_url, :text
  end

  def self.down
    remove_column :events, :ticket_url
  end
end
