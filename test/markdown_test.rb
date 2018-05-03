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
    result =~ /<p>(.*)<\/p>/
    para = $1
    assert_equal(expected, para)
  end


  def test_convert_tcy
    md = Cheepub::Markdown.new("平成^30^年^!?^\n")
    expected = %q{平成<span class="tcy">30</span>年<span class="tcy">!?</span>}
    result = md.convert
    result =~ /<p>(.*)<\/p>/
    para = $1
    assert_equal(expected, para)
  end

  def test_convert_footnote
    md = Cheepub::Markdown.new("テスト[^1]です。\n\n[^1]: テストの脚注です。\n")
    expected = <<-EOB
    <p>テスト<sup id="fnref:1"><a href="#fn:1" class="footnote">1</a></sup>です。</p>

<div class="footnotes">
  <ol>
    <li id="fn:1">
      <p>テストの脚注です。 <a href="#fnref:1" class="reversefootnote">&#8617;</a></p>
    </li>
  </ol>
</div>
EOB
    result = md.convert
    result =~ /<body[^>]+>\n(.*)  +<\/body>/m
    para = $1
    assert_equal(expected, para)
  end
end
