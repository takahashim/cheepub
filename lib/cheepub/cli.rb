module Cheepub
  class CLI < Clamp::Command
    option ["-v", "--version"], :flag, "Show version" do
      puts Cheepub::VERSION
      exit(0)
    end

    parameter "SRC", "source file"

    def execute
      gen = Cheepub::Generator.new(src)
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
