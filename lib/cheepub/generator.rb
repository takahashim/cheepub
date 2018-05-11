module Cheepub
  class Generator

    ROLES = %i{aut edt trl ill cov cre pht cwt nrt}

    def initialize(src, params)
      if src.kind_of? Cheepub::Content
        @src = nil
        @content = src
      else
        @src = src
        @content = Cheepub::Content.new(File.read(@src))
      end
      @params = params
    end

    def execute
      params = @content.header.merge(@params){|key, val, arg_val| arg_val.nil? ? val : arg_val}
      check_params(params)
      apply_params(params)
      output_file(params)
    end

    def output_file
      raise NotImplementedError
    end

    def parse_creator(creator)
      case creator
      when nil
        return
      when String
        add_creator(name, "aut")
      else
        creator.each do |role, name|
          if !ROLES.include?(role)
            raise Cheepub::Error, "invalid role: '#{role}' for creator '#{name}'."
          end
          add_creator(name, role)
        end
      end
    end

    def add_creator(name, role)
      raise NotImplementedError
    end

    def check_params(params)
      if !params[:author] || !params[:title]
        raise Cheepub::Error, "you must use `--author` and `--title`, or add front-matter in Markdown file."
      end
    end

    def apply_params(params)
      raise NotImplementedError
    end
  end
end
