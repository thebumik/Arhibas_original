class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.string :ip
      t.integer :project_id

      t.timestamps
    end

    add_index :votes, :project_id
  end

  def self.down
    drop_table :votes
  end
end
