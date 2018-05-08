module Cheepub
  class CLI < Clamp::Command
    using Cheepub::ExtHash

    option ["-v", "--version"], :flag, "print version" do
      puts Cheepub::VERSION
      exit(0)
    end
    option ["--author"], "AUTOR", "set author of the book"
    option ["--title"],  "TITLE", "set title of the book"
    option ["--config"],  "CONFIG", "set configuration file"
    option ["--latex"],  :flag, "generate PDF with LaTeX"
    option ["-o", "--output"], "EPUBFILE", "set output filename", attribute_name: :output
    option ["--[no-]titlepage"],  :flag, "add titlepage (or not)"

    parameter "SRC", "source file"

    def execute
      params = {}
      if config
        params = YAML.safe_load(config).symbolize_keys!
      end
      params[:author] = author
      params[:title] = title
      params[:output] = output
      params[:titlepage] = titlepage?
      if latex?
        gen = Cheepub::Generator::Latex.new(src, params)
      else
        gen = Cheepub::Generator::Epub.new(src, params)
      end
      begin
        gen.execute
      rescue Cheepub::Error => e
        puts "Error: #{e.message}"
        if $DEBUG
          puts e.backtrace
        end
        exit(1)
      end
    end
  end
end
