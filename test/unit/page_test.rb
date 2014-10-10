# == Schema Information
#
# Table name: pages
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  body          :text
#  body_markdown :text
#  position      :integer
#  published     :boolean         default(TRUE)
#  created_at    :datetime
#  updated_at    :datetime
#  slug          :string(255)
#

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
