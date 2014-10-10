class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size
      t.datetime :data_updated_at
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :assetable_id
      t.string  :assetable_type
      t.timestamps
    end

    add_index :assets, :assetable_id
    add_index :assets, :assetable_type
  end

  def self.down
    drop_table :assets
  end
end
