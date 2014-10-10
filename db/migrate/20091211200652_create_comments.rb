class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :author
      t.boolean :active, :default => false
      t.text :body
      t.integer :project_id # _fk

      t.timestamps
    end

    add_index :comments, :project_id
  end

  def self.down
    drop_table :comments
  end
end
