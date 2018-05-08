require "oga"
require "cheepub/heading_item"
require "cheepub/heading_parser/handler"

module Cheepub
  class HeadingParser
    def initialize
    end

    def parse_files(files)
      heading_list = files.map{ |filename, content| parse_html_heading(filename, content) }.flatten
      root = layering_heading(heading_list)
      root
    end

    def parse_html_heading(filename, content)
      handler = Cheepub::HeadingParser::Handler.new(filename)
      Oga::HTML::SaxParser.new(handler, content).parse
      handler.result
    end

    def layering_heading(list)
      root = HeadingItem.new(level: 0, children: [])
      prev = root

      list.each do |item|
        next if !item[:id] || item[:content].empty?
        node = HeadingItem.new(id: item[:id], level: item[:level], name: item[:name],
                               content: item[:content], filename: item[:filename], children: [])
        concat_node(prev, node)
        prev = node
      end

      root
    end

    def concat_node(prev, node)
      if node.level == prev.level + 1
        prev.add_child(node)
      elsif node.level == prev.level
        prev.add_sibling(node)
      elsif node.level > prev.level
        prev.add_descendant(node)
      else ## node.level < prev.level
        prev.add_ancestor(node)
      end
    end
  end
end
