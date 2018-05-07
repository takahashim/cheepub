require 'erb'

module Cheepub
  class Nav

    def initialize(content)
      @content = content
      @root = @body = nil
    end

    def parse_content
      parser = HeadingParser.new()
      list = make_file_list()
      @root = parser.parse_files(list)
      @root
    end

    def to_html
      template = File.read(File.join(File.dirname(__FILE__), "templates/nav.xhtml.erb"))
      @body = @root.to_html_ol
      erb = ERB.new(template)
      str = erb.result(binding)
      str
    end

    def make_file_list
      @content.to_enum(:each_html_with_filename).map{|html,filename| [filename, html]}.to_a
    end
  end
end
