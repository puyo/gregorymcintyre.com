module Ensmarten
  def self.ensmarten(text)
    text = text.dup
    i = 0
    blocks = {}
    text.gsub!(/```.*?```/m) do |text|
      key = "__BLOCK_#{i}__"
      blocks[key] = text
      i += 1
      key
    end
    text.gsub!(/``/, '&ldquo;')
    text.gsub!(/''/, '&rdquo;')
    text.gsub!(/`(.*?)`/m, '__RQUO__\1__RQUO__')
    text.gsub!(/`/, '&lsquo;')
    text.gsub!(/'/, '&rsquo;')
    text.gsub!(/---/, '&mdash;')
    text.gsub!(/--/, '&ndash;')
    text.gsub!(/(\s)-(\s)/, '\1&ndash;\2')
    text.gsub!(/\.{3}/, '&hellip;')
    text.gsub!(/\(c\)/, '&copy;')
    text.gsub!(/\(tm\)/, '&trade;')
    text.gsub!(/\(r\)/, '&reg;')
    text.gsub!(/\b3\/4/, '&frac34;')
    text.gsub!(/\b1\/4/, '&frac14;')
    text.gsub!(/\b1\/2/, '&frac12;')
    text.gsub!(/__BLOCK_\d+__/) do |key|
      blocks[key]
    end
    text.gsub!('__RQUO__', '`')
    text
  end
end
