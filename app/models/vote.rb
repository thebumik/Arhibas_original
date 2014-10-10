# == Schema Information
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  ip         :string(255)
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  belongs_to :project
end
