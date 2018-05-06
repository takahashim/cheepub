require "test_helper"
require "cheepub"

class GeneratorTest < Test::Unit::TestCase
  def test_params_checking_without_author
    gen = Cheepub::Generator.new(Cheepub::Content.new(""), {title: "test title"})
    assert_raise(Cheepub::Error) do
      gen.execute
    end
  end

  def test_parse_creator
    creator = {aut: "foo", cov: "bar"}
    gen = Cheepub::Generator.new(Cheepub::Content.new(""))
    book = GEPUB::Book.new
    gen.parse_creator(book, creator)
    list = book.creator_list
    assert_equal :aut, list[0].role.content
    assert_equal "foo", list[0].content
    assert_equal :cov, list[1].role.content
    assert_equal "bar", list[1].content
  end
end
