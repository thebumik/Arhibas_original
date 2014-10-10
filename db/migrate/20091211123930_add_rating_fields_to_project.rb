class AddRatingFieldsToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :rating_avg, :decimal, :precision => 10, :scale => 2, :default => 0
    add_column :projects, :rating_total, :integer, :default => 0
    add_column :projects, :rating_last_value, :integer
  end

  def self.down
    remove_column :projects, :rating_last_value
    remove_column :projects, :rating_total
    remove_column :projects, :rating_avg
  end
end
