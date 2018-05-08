require "test_helper"

class HeadingParserTest < Test::Unit::TestCase
  def test_convert
    parser = Cheepub::HeadingParser.new()
    filename = File.join(FIXTURES_DIR, "heading_sample.md")
    html = Cheepub::Markdown.parse(filename).convert
    list = [["heading_sample.html", html]]
    root = parser.parse_files(list)
    expected = File.read(File.join(FIXTURES_DIR, "heading_sample.html"))
    assert_equal expected, root.to_html_ol
  end
end
