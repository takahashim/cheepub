module Cheepub
  class CLI < Clamp::Command
    using Cheepub::ExtHash

    option ["-v", "--version"], :flag, "Show version" do
      puts Cheepub::VERSION
      exit(0)
    end
    option ["--author"], "AUTOR", "author of the book"
    option ["--title"],  "TITLE", "title of the book"
    option ["--config"],  "CONFIG", "configuration file"
    option ["-o", "--out"], "EPUBFILE", "output epub filename", attribute_name: :epubfile

    parameter "SRC", "source file"

    def execute
      params = {}
      if config
        params = YAML.safe_load(config).symbolize_keys!
      end
      params[:author] = author if author
      params[:title] = title if title
      params[:epubfile] = epubfile if epubfile
      gen = Cheepub::Generator.new(src, params)
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
