
module Ensmarten
  def self.ensmarten(text)
    text = text.dup
    text.gsub!(/```/, '___triple__')
    text.gsub!(/``/, '&ldquo;')
    text.gsub!(/''/, '&rdquo;')
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
    text.gsub!(/___triple__/, '```')
    text
  end
end

# ----------------------------------------------------------------------

require 'redcarpet'

class EnsmartenedHTML < Redcarpet::Render::HTML
  def preprocess(text)
    Ensmarten.ensmarten(text)
  end
end

module Middleman
  module Blog
    module BlogArticle
      def smart_title
        Ensmarten.ensmarten(title)
      end
    end
  end
end
