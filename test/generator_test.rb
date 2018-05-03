require "test_helper"
require "cheepub"

class GeneratorTest < Test::Unit::TestCase
  def test_separate
    src = <<-EOB
test

=========

foo
bar

================================

buz
EOB
    gen = Cheepub::Generator.new(src)
    expected = ["test\n", "foo\nbar\n", "buz\n"]
    result = gen.separate_pages(src)
    assert_equal expected, result
  end

  def test_separate_nosep
    src = <<-EOB
foo
bar
buz
EOB
    gen = Cheepub::Generator.new(src)
    expected = ["foo\nbar\nbuz\n"]
    result = gen.separate_pages(src)
    assert_equal expected, result
  end

  def test_parse_frontmatter
    src = <<-EOB
---
title: test
author: foo
language: ja
---
# hello

hello, world!
EOB
    gen = Cheepub::Generator.new(src)
    head, body = gen.parse_frontmatter(src)
    expected_head = {title: "test",
                     author: "foo",
                     language: "ja"}
    expected_body = <<-EOB
# hello

hello, world!
EOB
    assert_equal expected_head, head
    assert_equal expected_body, body
  end
end
