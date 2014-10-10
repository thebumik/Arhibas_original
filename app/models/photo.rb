# == Schema Information
#
# Table name: photos
#
#  id                :integer         not null, primary key
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  project_id        :integer
#

class Photo < ActiveRecord::Base
  belongs_to :project
  ALOWED_CONTENT_TYPES = ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif']

  has_attached_file :data,
  :styles => {
    :thumb => "85x55#",
    :medium => "180x90#",
    :large => "610x314#",
    :slide => "135x180#"
  },
  :path => ":rails_root/public/images/projects/:id/:style/:basename.:extension",
  :url  => "projects/:id/:style/:basename.:extension"

  validates_attachment_presence :data
  validates_attachment_content_type :data, :content_type => ALOWED_CONTENT_TYPES

  named_scope :limit, lambda{|limit|
    {:limit => limit}
  }

  def self.destroy_pics(project, photos)
    Photo.find(photos, :conditions => { :project_id => project }).each(&:destroy)
  end
end
