require 'erb'

module Cheepub
  class Nav

    def self.generate(content)
      self.new.parse_content(content)
    end

    def initialize
    end

    def parse_content(content)
      template = File.read(File.join(File.dirname(__FILE__), "templates/nav.xhtml.erb"))
      parser = HeadingParser.new()
      list = make_file_list(content)
      root = parser.parse_files(list)
      @body = root.to_html_ol
      erb = ERB.new(template)
      str = erb.result(binding)
      str
    end

    def make_file_list(content)
      content.to_enum(:each_html_with_filename).map{|html,filename| [filename, html]}.to_a
    end
  end
end
