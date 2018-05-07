module Cheepub
  class HeadingItem

    attr_reader :id, :level, :name, :filename, :content, :children
    attr_accessor :parent

    def initialize(id:nil, level:, name:nil, filename:nil, content:nil, children:nil, parent:nil)
      @id = id
      @level = level
      @name = name
      @filename = filename
      @content = content
      @children = children
      @parent = parent
    end

    def add_child(node)
      children << node
      node.parent = self
      node
    end

    def add_sibling(node)
      parent.add_child(node)
    end

    def add_descendant(node)
      current = self
      while current.level + 1 != node.level
        item = HeadingItem.new(level: current.level+1, children: [])
        current.add_child(item)
        current = item
      end
      current.add_child(node)
    end

    def add_ancestor(node)
      current = self
      while current.level != node.level
        current = current.parent
      end
      current.add_sibling(node)
    end

    def dump
      print "*" * level
      print "{id:#{id}} content: #{content}\n"
      children.each do |child|
        child.dump
      end
    end

    def to_html_ol
      indent = "  " * (2 * level)
      buf = ""
      if level > 0
        buf << "#{indent}<li>\n"
      end
      if id && content.length > 0
        buf << "  #{indent}<a href=\"#{filename}\##{id}\">#{content}</a>\n"
      elsif level > 0
        buf << "  #{indent}<span>&#160;</span>\n"
      end
      if !children.empty?
        buf << "  #{indent}<ol>\n" +
               children.map(&:to_html_ol).join("") +
               "  #{indent}</ol>\n"
      end
      if level > 0
        buf << "#{indent}</li>\n"
      end
      buf
    end
  end
end
