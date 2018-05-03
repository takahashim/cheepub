require "test_helper"
require "cheepub"

class MarkdwnTest < Test::Unit::TestCase

  def test_convert
    md = Cheepub::Markdown.new("foo*bar*buz")
    expected = <<-EOB
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja" lang="ja">
  <head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="style.css" type="text/css" />
    <title>EPUB sample</title>
    <meta name="generator" content="Cheepub 0.1.0 with kramdown 1.16.2" />
  </head>
  <body class="bodymatter" epub:type="bodymatter">
    <p>foo<em>bar</em>buz</p>
  </body>
</html>
EOB
    result = md.convert
    assert_equal(expected, result)
  end
end
