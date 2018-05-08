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
    option ["-o", "--out"], "EPUBFILE", "set output epub filename", attribute_name: :epubfile
    option ["--[no-]titlepage"],  :flag, "add titlepage (or not)"

    parameter "SRC", "source file"

    def execute
      params = {}
      if config
        params = YAML.safe_load(config).symbolize_keys!
      end
      params[:author] = author
      params[:title] = title
      params[:epubfile] = epubfile
      params[:titlepage] = titlepage?
      gen = Cheepub::Generator::Epub.new(src, params)
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
