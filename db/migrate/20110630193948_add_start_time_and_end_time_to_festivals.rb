class AddStartTimeAndEndTimeToFestivals < ActiveRecord::Migration
  def self.up
    add_column :festivals, :start_time, :datetime
    add_column :festivals, :end_time, :date
  end

  def self.down
    remove_column :festivals, :start_time
    remove_column :festivals, :end_time
  end
end
