require "test_helper"
require "cheepub"
require "pp"

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

  def test_convert_table
    md = Cheepub::Markdown.new(<<EOB)
| Left align | Right align | Center align |
|:-----------|------------:|:------------:|
| left       | right       | center       |
| aligned    | aligned     | aligned      |
EOB
    expected = <<-EOB
    <table>
  <thead>
    <tr>
      <th style="text-align: left">Left align</th>
      <th style="text-align: right">Right align</th>
      <th style="text-align: center">Center align</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left">left</td>
      <td style="text-align: right">right</td>
      <td style="text-align: center">center</td>
    </tr>
    <tr>
      <td style="text-align: left">aligned</td>
      <td style="text-align: right">aligned</td>
      <td style="text-align: center">aligned</td>
    </tr>
  </tbody>
</table>
EOB
    result = md.convert
    result =~ /<body[^>]+>\n(.*)  +<\/body>/m
    para = $1
    assert_equal(expected, para)
  end

  def test_convert_table2
    md = Cheepub::Markdown.new(<<EOB)
| One | Two   |
|-----+-------|
| my  | table |
| is  | nice  |
EOB
    expected = <<-EOB
    <table>
  <thead>
    <tr>
      <th>One</th>
      <th>Two</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>my</td>
      <td>table</td>
    </tr>
    <tr>
      <td>is</td>
      <td>nice</td>
    </tr>
  </tbody>
</table>
EOB
    result = md.convert
    result =~ /<body[^>]+>\n(.*)  +<\/body>/m
    para = $1
    assert_equal(expected, para)
  end

  def test_convert_table3
    md = Cheepub::Markdown.new(<<EOB)
|Markdown | Less | Pretty|
|--- | --- | ---|
|*Still* | `renders` | **nicely**|
|1 | 2 | 3|
EOB
    expected = <<-EOB
    <table>
  <thead>
    <tr>
      <th>Markdown</th>
      <th>Less</th>
      <th>Pretty</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><em>Still</em></td>
      <td><code>renders</code></td>
      <td><strong>nicely</strong></td>
    </tr>
    <tr>
      <td>1</td>
      <td>2</td>
      <td>3</td>
    </tr>
  </tbody>
</table>
EOB
    result = md.convert
    result =~ /<body[^>]+>\n(.*)  +<\/body>/m
    para = $1
    assert_equal(expected, para)
  end

  def test_convert_sample
    content = File.read(File.join(FIXTURES_DIR, "sample.md"))
    Dir.chdir(FIXTURES_DIR) do
      Dir.mktmpdir do |tmpdir|
        md = Cheepub::Markdown.new(content, asset_store: Cheepub::AssetStore.new(tmpdir, "."))
        result = md.to_html
        expected = File.read(File.join(FIXTURES_DIR, "sample.html")).sub("X.X.X", Cheepub::VERSION).sub("Y.Y.Y", Kramdown::VERSION)
        assert_equal(expected, result)
      end
    end
  end

  def test_convert_latex
    content = File.read(File.join(FIXTURES_DIR, "sample.md"))

    md = Cheepub::Markdown.new(content)
    result = md.to_latex
    expected = File.read(File.join(FIXTURES_DIR, "sample.tex"))
    assert_equal(expected, result)
  end

  def test_convert_hash_ast
    content = File.read(File.join(FIXTURES_DIR, "sample.md"))

    md = Cheepub::Markdown.new(content)
    hash = md.to_hash_ast
    out = []
    PP.pp(hash, out)
    result = out.join
    expected = File.read(File.join(FIXTURES_DIR, "sample.hash_ast"))
    assert_equal(expected, result)
  end

  def test_convert_json
    content = File.read(File.join(FIXTURES_DIR, "sample.md"))

    md = Cheepub::Markdown.new(content)
    json_orig = md.to_json
    json = JSON.pretty_generate(JSON.parse(json_orig)) + "\n"
    expected = File.read(File.join(FIXTURES_DIR, "sample.json"))
    assert_equal(expected, json)
  end
end
