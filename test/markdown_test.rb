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

  def test_convert_ruby
    md = Cheepub::Markdown.new("この問題は{今度|こんど}の{試験|テスト}に出る。\n")
    expected = "この問題は<ruby><rb>今度</rb><rp>（</rp><rt>こんど</rt><rp>）</rp></ruby>の<ruby><rb>試験</rb><rp>（</rp><rt>テスト</rt><rp>）</rp></ruby>に出る。"
    result = md.convert
    p result
    result =~ /<p>(.*)<\/p>/
    para = $1
    p para
    assert_equal(expected, para)
  end


  def test_convert_tcy
    md = Cheepub::Markdown.new("平成^30^年^!?^\n")
    expected = %q{平成<span class="tcy">30</span>年<span class="tcy">!?</span>}
    result = md.convert
    p result
    result =~ /<p>(.*)<\/p>/
    para = $1
    p para
    assert_equal(expected, para)
  end
end
