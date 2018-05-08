#!/usr/bin/env ruby
#
# convert HTML ruby format into DenDen Markdown ruby format
#
# if you convert html in Shift_JIS, use:
#
#   $ ruby -Eshift_jis conv_ruby.rb  original.html > converted.html
#

RUBY_PATTERN = /<ruby><rb>([^<]+)<\/rb>(?:<rp>[^<]+<\/rp>)?<rt>([^<]+)<\/rt>(?:<rp>[^<]+<\/rp>)?<\/ruby>/

def conv_ruby(str)
  str.gsub(RUBY_PATTERN) do |matched|
    "{#{$1}|#{$2}}"
  end
end

if ARGV.empty?
  print "usage: ruby conv_ruby.rb [htmlfile]\n"
  exit 0
end

ARGV.each do |file|
  File.open(file) do |f|
    f.each_line do |line|
      conved = conv_ruby(line)
      print conved
    end
  end
end
