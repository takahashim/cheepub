require "test_helper"

class NavTest < Test::Unit::TestCase
  def test_to_html
    filename = File.join(FIXTURES_DIR, "heading_sample.md")
    content = Cheepub::Content.new(File.read(filename))
    nav = Cheepub::Nav.new(content)
    expected = File.read(File.join(FIXTURES_DIR, "heading_sample.html"))
    result = nav.to_html
    ## remove header/footer
    result.gsub!(/\A.*<h2>目次<\/h2>\n      /m, "")
    result.gsub!(/bodymatter_0.xhtml/, "heading_sample.html")
    result.gsub!(/  <\/nav>\n\s+<nav.*\z/m, "")
    assert_equal expected, result
  end
end
