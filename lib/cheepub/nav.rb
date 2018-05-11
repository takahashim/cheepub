require 'erb'

module Cheepub
  class Nav

    attr_reader :root

    def initialize(content)
      @content = content
      @root = @body = nil
      parse
    end

    def to_html
      template = File.read(File.join(Cheepub::TEMPLATES_DIR, "nav.xhtml.erb"))
      @body = @root.to_html_ol
      erb = ERB.new(template)
      return erb.result(binding)
    end


    private

    def parse
      parser = HeadingParser.new()
      list = make_file_list()
      @root = parser.parse_files(list)
    end

    def make_file_list
      @content.to_enum(:each_content_with_filename, "xhtml").map{|html,filename| [filename, html]}.to_a
    end
  end
end
