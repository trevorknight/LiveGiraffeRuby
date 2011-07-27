class ChangeDatetimeForFestivals < ActiveRecord::Migration
  def self.up
    remove_column :festivals, :end_time
    add_column :festivals, :end_time, :datetime
  end

  def self.down
    remove_column :festivals, :end_time
    add_column :festivals, :end_time, :date
  end
end
