# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  author     :string(255)
#  active     :boolean
#  body       :text
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :project

  # validations
  validates_presence_of :author, :body

  # named scopes
  named_scope :activated, :conditions => { :active => true }
end
