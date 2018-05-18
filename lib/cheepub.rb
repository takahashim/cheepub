## suppress warning in 3rd party libraries
tmp = $VERBOSE
$VERBOSE = false
require "clamp"
require "oga"
require "rouge"
$VERBOSE = tmp

require "cheepub/version"
require "cheepub/error"
require "cheepub/ext_hash"
require "cheepub/markdown"
require "kramdown/parser/cheemarkdown"
require "cheepub/cli"
require "cheepub/generator"
require "cheepub/generator/epub"
require "cheepub/generator/latex"
require "cheepub/content"
require "cheepub/heading_parser"
require "cheepub/heading_item"
require "cheepub/nav"
require "cheepub/converter/cheelatex"
require "cheepub/converter/cheehtml"
require "cheepub/asset_store"

module Cheepub
  TEMPLATES_DIR = File.join(File.dirname(__FILE__), "../templates")
end
