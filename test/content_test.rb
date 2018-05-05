require "test_helper"
require "cheepub"

class ContentTest < Test::Unit::TestCase
  def test_separate
    src = <<-EOB
test

=========

foo
bar

================================

buz
EOB
    content = Cheepub::Content.new(src)
    expected = ["test\n", "foo\nbar\n", "buz\n"]
    assert_equal expected, content.pages
  end

  def test_separate_minus
    src = <<-EOB
test

------

foo

---

bar

------------------------------

buz
EOB
    content = Cheepub::Content.new(src)
    expected = ["test\n", "foo\n\n---\n\nbar\n", "buz\n"]
    assert_equal expected, content.pages
  end

  def test_separate_nosep
    src = <<-EOB
foo
bar
buz
EOB
    content = Cheepub::Content.new(src)
    expected = ["foo\nbar\nbuz\n"]
    assert_equal expected, content.pages
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
    content = Cheepub::Content.new(src)
    expected_header = {title: "test",
                       author: "foo",
                       language: "ja"}
    expected_body = <<-EOB
# hello

hello, world!
EOB
    assert_equal expected_header, content.header
    assert_equal expected_body, content.body
  end
end
