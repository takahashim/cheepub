module Cheepub
  class CLI < Clamp::Command
    option ["-v", "--version"], :flag, "Show version" do
      puts Cheepub::VERSION
      exit(0)
    end

    parameter "SRC", "source file"

    def execute
      gen = Cheepub::Generator.new(src)
      gen.execute
    end
  end
end
