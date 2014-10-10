class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :categories, :force => true do |t|
      t.integer  :position
      t.string   :name
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :parent_id
      t.boolean  :published,   :default => true
      t.integer  :lft
      t.integer  :rgt
      t.integer  :stage
    end
    add_index :categories, [:lft, :rgt], :name => "index_categories_on_lft_and_rgt"
    add_index :categories, :lft, :name => "index_categories_on_lft"
    add_index :categories, :parent_id, :name => "index_categories_on_parent_id"
    add_index :categories, :rgt, :name => "index_categories_on_rgt"

    create_table :pages, :force => true do |t|
      t.string   :name
      t.text     :body
      t.text     :body_markdown
      t.integer  :position
      t.boolean  :published,     :default => true
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :photos, :force => true do |t|
      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size
      t.datetime :data_updated_at
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :project_id
    end
    add_index :photos, :project_id, :name => "index_photos_on_project_id"

    create_table :projects, :force => true do |t|
      t.string   :name
      t.string   :customer
      t.string   :location
      t.string   :arhitect
      t.integer  :completion
      t.integer  :position
      t.text     :description
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :published,   :default => true
      t.integer  :category_id
    end
    add_index :projects, :category_id, :name => "index_projects_on_category_id"

    create_table :translations, :force => true do |t|
      t.string  :name
      t.string  :customer
      t.string  :location
      t.string  :arhitect
      t.text    :description
      t.integer :translationable_id
      t.string  :translationable_type
      t.string  :lang
      t.text    :body
      t.text    :body_markdown
    end
    add_index :translations, :lang, :name => "index_translations_on_lang"
    add_index :translations, :translationable_id, :name => "index_translations_on_translationable_id"
    add_index :translations, :translationable_type, :name => "index_translations_on_translationable_type"
  end

  def self.down
    drop_table :translations
    drop_table :projects
    drop_table :photos
    drop_table :pages
    drop_table :categories
  end
end
