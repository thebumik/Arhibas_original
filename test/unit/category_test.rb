# == Schema Information
#
# Table name: categories
#
#  id          :integer         not null, primary key
#  position    :integer
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  parent_id   :integer
#  published   :boolean         default(TRUE)
#  lft         :integer
#  rgt         :integer
#  stage       :integer
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
