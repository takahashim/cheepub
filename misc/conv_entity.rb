#!/usr/bin/env ruby
#
# convert HTML character entity into UTF-8 character
#

ENT_PATTERN = /&#([0-9A-Fa-f]+);/
ENT_X_PATTERN = /&#x([0-9A-Fa-f]+);/

def conv_ruby(str)
  str.gsub(ENT_PATTERN) do |matched|
    sprintf("%c", $1.to_i)
  end.gsub(ENT_X_PATTERN) do |matched|
    sprintf("%c", $1.to_i(16))
  end
end

if ARGV.empty?
  print "usage: ruby conv_entity.rb [htmlfile]\n"
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
