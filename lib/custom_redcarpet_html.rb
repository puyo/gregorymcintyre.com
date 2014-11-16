require 'middleman-core/renderers/redcarpet'
require 'middleman-syntax/extension'
require 'ensmarten'

class CustomRedcarpetHTML < Middleman::Renderers::MiddlemanRedcarpetHTML
  include Middleman::Syntax::RedcarpetCodeRenderer

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
