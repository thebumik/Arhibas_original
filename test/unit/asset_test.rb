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

require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
