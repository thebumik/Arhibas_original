# == Schema Information
#
# Table name: projects
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  customer          :string(255)
#  location          :string(255)
#  arhitect          :string(255)
#  completion        :integer
#  position          :integer
#  description       :text
#  created_at        :datetime
#  updated_at        :datetime
#  published         :boolean         default(TRUE)
#  category_id       :integer
#  rating_avg        :decimal(10, 2)  default(0.0)
#  rating_total      :integer         default(0)
#  rating_last_value :integer
#  body              :text
#  body_markdown     :text
#  in_sidebar        :boolean         default(TRUE)
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
