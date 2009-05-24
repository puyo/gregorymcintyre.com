#!/usr/bin/ruby

begin
  require 'rubygems'
  gem 'hpricot'
rescue
end

require 'hpricot'
require 'pp'

docs = "index code computergames drawing books roleplay music".split
replacements = [
  [".left", "nav.html"],
  ["#urchin", "urchin.html"],
]

docs.each do |base|
  filename = "#{base}.html"
  doc = nil
  File.open(filename) do |f|
    doc = Hpricot.parse(f)
  end

  replacements.each do |selector, file|
    replacement = Hpricot.parse(File.open(file))
    doc.search(selector).each do |elem|
      elem.parent.replace_child(elem, replacement.root)
    end
  end

  File.open(filename, 'w') do |f|
    f.print doc.to_s
  end
  puts filename
end
