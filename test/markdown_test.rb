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
    <title>content</title>
    <meta name="generator" content="Cheepub #{Cheepub::VERSION} with kramdown #{Kramdown::VERSION}" />
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
    expected = "この問題は<ruby>今度<rt>こんど</rt></ruby>の<ruby>試験<rt>テスト</rt></ruby>に出る。"
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

  def test_convert_centering
    md = Cheepub::Markdown.new("{: .centering}\nこの行はセンタリングするはずです\n\nこの行はセンタリングしません。\n")
    expected = %Q{    <p class="centering">この行はセンタリングするはずです</p>\n\n<p>この行はセンタリングしません。</p>\n}
    result = md.convert
    result =~ /<body[^>]+>\n(.*)  +<\/body>/m
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

  def test_convert_sample
    content = File.read(File.join(FIXTURES_DIR, "sample.md"))

    md = Cheepub::Markdown.new(content)
    result = md.convert
    expected = File.read(File.join(FIXTURES_DIR, "sample.html")).sub("X.X.X", Cheepub::VERSION).sub("Y.Y.Y", Kramdown::VERSION)
    assert_equal(expected, result)
  end
end
