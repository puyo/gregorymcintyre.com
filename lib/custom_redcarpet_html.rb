require 'middleman-core/renderers/redcarpet'
require 'middleman-syntax/extension'
require 'ensmarten'

class CustomRedcarpetHTML < Middleman::Renderers::MiddlemanRedcarpetHTML
  include Middleman::Syntax::RedcarpetCodeRenderer

  def initialize
    @r = Redcarpet::Markdown.new(Middleman::Renderers::MiddlemanRedcarpetHTML)
    super
  end

  def preprocess(text)
    Ensmarten.ensmarten(text)
  end

  def block_code(code, language)
    case language
    when 'poem' then poem(code)
    when 'prompt' then prompt(code)
    else super(code, language)
    end
  end

  private

  def prompt(text)
    %{<div class="prompt">#{@r.render(text.strip)}</div>}
  end

  def poem(text)
    %{<div class="poem"><div class="body">#{lined_paragraphs(text)}</div></div>}
  end

  def lined_paragraphs(input)
    input.strip.split(/\n\n/).map do |paragraph|
      "<p>#{lines(paragraph)}</p>"
    end.join
  end

  def lines(input)
    input.split(/\n/).map do |line|
      %{<span class="line">#{line}</span><br/>}
    end.join
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
