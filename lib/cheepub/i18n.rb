require 'cheepub/ext_hash'

module Cheepub
  class I18n
    using Cheepub::ExtHash

    ## some codes are from Ruby's I18n https://github.com/svenfuchs/i18n/

    class InterpolateError < ArgumentError
      def initialize(key, values, str)
        @key, @values, @str = key, values, str
        super "missing interpolation argument #{key.inspect} in #{str.inspect} (#{values.inspect} given)"
      end
    end

    class InvalidLocaleData < ArgumentError
      attr_reader :filename
      def initialize(filename, exception_message)
        @filename, @exception_message = filename, exception_message
        super "can not load translations from #{filename}: #{exception_message}"
      end
    end

    INTERPOLATION_PATTERN = %r<(?:%%|%\{([A-Za-z0-9_]+)\})>

    def self.load_path=(path)
      @i18n.load_path = path
    end

    def self.load_path
      @i18n.load_path ||= []
      @i18n.load_path
    end

    def self.available_locales=(locales)
      @i18n.available_locales = locales
    end

    def self.available_locales
      @i18n.available_locales
    end

    def self.default_locale=(locale)
      @i18n.default_locale = locale
    end

    def self.t(*args)
      key = args.shift
      @i18n.translate(key, args)
    end

    @i18n = self.new

    attr_accessor :load_path, :available_locales, :default_locale

    def initialize
      @translations = {}
      @available_locales = [:ja, :en]
      @default_locales = :en
    end

    def load_files(*files)
      filenames = I18n.load_path if filenames.empty?
      filenames.each { |filename| load_data(filename) }
    end

    def load_data(file)
      begin
        data = nil
        if file.kind_of?(Hash)
          data = file
        else
          content = File.read(file)
          data = YAML.safe_load(content)
        end
        data.symbolize_keys!
        pp data
        data.each { |locale, d| store_translations(locale, d || {}) }
      rescue => e
        raise InvalidLocaleData.new(file, e.inspect)
      end
    end

    def store_translations(locale, data)
      locale = locale.to_sym
      if !I18n.available_locales.include?(locale)
        return data
      end
      translations[locale] ||= {}
      data.symbolize_keys!
      translations[locale].deep_merge!(data)
    end

    def translations
      @translations
    end

    def translate(key, options = {})
      locale ||= @default_locale
      entry = lookup(locale, key)
      interpolate(entry, options)
    end

    alias_method :t, :translate

    def lookup(locale, key)
      translations[locale][key] rescue nil
    end

    def interpolate(str, values)
      return "" if str.nil?
      str.gsub(INTERPOLATION_PATTERN) do |match|
        if match == '%%'
          '%'
        else
          key = $1.to_sym
          if values.key?(key)
            values[key]
          else
            raise I18n::InterpolateError.new(key, values, str)
          end
        end
      end
    end
  end

  I18n.load_path += Dir["../../locale/*.yml"]
  I18n.available_locales = [:en, :ja]
  I18n.default_locale = :ja

end
