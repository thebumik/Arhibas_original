# == Schema Information
#
# Table name: assets
#
#  id                :integer         not null, primary key
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  assetable_id      :integer
#  assetable_type    :string(255)
#

class Asset < ActiveRecord::Base
  belongs_to :assetable, :polymorphic => true
  ALOWED_CONTENT_TYPES = ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif']

  has_attached_file :data,
  :styles => {
    :thumb => "85x55#"
  },
  :path => ":rails_root/public/assets/:style/:id/:basename.:extension",
  :url  => "/assets/:style/:id/:basename.:extension"

  validates_attachment_presence :data
  validates_attachment_content_type :data, :content_type => ALOWED_CONTENT_TYPES

  named_scope :limit, lambda{|limit|
    {:limit => limit}
  }

  def self.destroy_pics(assetable_type, assetable_id, photos)
    Asset.find(photos, :conditions => { :assetable_type => assetable_type, :assetable_id => assetable_id, }).each(&:destroy)
  end
end
