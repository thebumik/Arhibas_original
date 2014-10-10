class AddBodyAndInSidebarToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :body, :text
    add_column :projects, :body_markdown, :text
    add_column :projects, :in_sidebar, :boolean, :default => true

    # update all existent projects
    Project.update_all :in_sidebar => true
  end

  def self.down
    remove_column :projects, :in_sidebar
    remove_column :projects, :body_markdown
    remove_column :projects, :body
  end
end
