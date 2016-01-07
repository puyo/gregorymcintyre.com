require 'middleman-core/renderers/redcarpet'
require 'middleman-syntax/extension'
require 'ensmarten'

class CustomRedcarpetHTML < Middleman::Renderers::MiddlemanRedcarpetHTML
  include Middleman::Syntax::RedcarpetCodeRenderer

  def preprocess(text)
    Ensmarten.ensmarten(text)
  end

  def image(link, title, alt_text)
    resource = scope.current_resource.children.find{|x| File.basename(x.source_file) == link }
    if resource
      link = resource.request_path
    end
    super(link, title, alt_text)
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
