require "test_helper"
require "gepub"

class CheepubTest < Test::Unit::TestCase
  def test_has_a_version_number
    assert ::Cheepub::VERSION
  end

  def test_has_gepub
    assert_const_defined(::GEPUB, "Book")
  end
end
