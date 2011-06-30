class CreateFestivals < ActiveRecord::Migration
  def self.up
    create_table :festivals do |t|
      t.string :name
      t.string :website

      t.timestamps
    end
  end

  def self.down
    drop_table :festivals
  end
end
