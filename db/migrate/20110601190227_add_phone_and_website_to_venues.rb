class AddPhoneAndWebsiteToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :website, :string
    add_column :venues, :phone, :integer
  end

  def self.down
    remove_column :venues, :phone
    remove_column :venues, :website
  end
end
