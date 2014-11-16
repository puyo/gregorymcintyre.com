require 'liquid'
require 'custom_redcarpet_html'

# Writing prompt tag.
class PromptTag < Liquid::Block
  def render(context)
    %{<div class="prompt">#{markdown.render(super.strip)}</div>}
  end

  def markdown
    Redcarpet::Markdown.new(CustomRedcarpetHTML)
  end
end

Liquid::Template.register_tag('prompt', PromptTag)
