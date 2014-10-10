# == Schema Information
#
# Table name: translations
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  customer             :string(255)
#  location             :string(255)
#  arhitect             :string(255)
#  description          :text
#  translationable_id   :integer
#  translationable_type :string(255)
#  lang                 :string(255)
#  body                 :text
#  body_markdown        :text
#

require 'test_helper'

class TranslationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
