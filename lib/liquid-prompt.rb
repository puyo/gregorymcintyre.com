require 'liquid'
require_relative './ensmarten'

# Writing prompt tag.
class PromptTag < Liquid::Block
  def render(context)
    %{<div class="prompt">#{markdown.render(super.strip)}</div>}
  end

  def markdown
    Redcarpet::Markdown.new(EnsmartenedHTML)
  end
end

Liquid::Template.register_tag('prompt', PromptTag)
