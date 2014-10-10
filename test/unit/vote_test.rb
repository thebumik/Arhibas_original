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

require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
