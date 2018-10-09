if __FILE__ == $0
  require 'bundler'
  Bundler.require
end

require 'middleman-core/renderers/redcarpet'
require 'middleman-syntax/extension'

def ensmarten(text)
  text
    .to_s
    .gsub(/```/, '___TRIPLE_TICK___')
    .gsub(/\*\*(.*?)\*\*/, '<strong>\1</strong>')
    .gsub(/\*(.*?)\*/, '<em>\1</em>')
    .gsub(/``/, '&ldquo;')
    .gsub(/''/, '&rdquo;')
    .gsub(/`(.*?)`/m, '__RQUO__\1__RQUO__')
    .gsub(/`/, '&lsquo;')
    .gsub(/'/, '&rsquo;')
    .gsub(/---/, '&mdash;')
    .gsub(/--/, '&ndash;')
    .gsub(/(\s)-(\s)/, '\1&ndash;\2')
    .gsub(/\.{3}/, '&hellip;')
    .gsub(/\(c\)/, '&copy;')
    .gsub(/\(tm\)/, '&trade;')
    .gsub(/\(r\)/, '&reg;')
    .gsub(/\b3\/4/, '&frac34;')
    .gsub(/\b1\/4/, '&frac14;')
    .gsub(/\b1\/2/, '&frac12;')
    .gsub('__RQUO__', '`')
    .gsub('___TRIPLE_TICK___', '```')
end

class CustomRedcarpetHTML < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    @r = Redcarpet::Markdown.new(Middleman::Renderers::MiddlemanRedcarpetHTML, {
      disable_indented_code_blocks: true
    })
    super
  end

  def block_code(text, language)
    case language
    when 'poem'
      poem(ensmarten(text))
    when 'prompt'
      prompt(ensmarten(text))
    when String
      Middleman::Syntax::Highlighter.highlight(text.chomp, language, {lexer_options: {}})
    else
      %(<pre><code>#{text.chomp}</code></pre)
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
      line.gsub!(/\S.*$/) { |m| @r.render(m)[3..-6] }
      %{<span class="line">#{line}</span><br/>}
    end.join
  end
end

module Middleman
  module Blog
    module BlogArticle
      def smart_title
        ensmarten(title)
      end
    end
  end
end

if __FILE__ == $0
  require 'minitest'
  require 'minitest/autorun'

  describe CustomRedcarpetHTML do
    before do
      @markdown = Redcarpet::Markdown.new(CustomRedcarpetHTML, {
        tables: true,
        autolink: true,
        gh_blockcode: true,
        fenced_code_blocks: true,
      })
    end

    it "works for no language blocks" do
      result = @markdown.render %Q{
```
Hello my 'pretty'
```
}
      expected = %{<pre><code>Hello my 'pretty'</code></pre}
      result.must_equal expected
    end

    it "works for code blocks" do
      result = @markdown.render %Q{
```ruby
puts 'Hello world'
```
}
      expected = %Q{<div class=\"highlight\"><pre class=\" ruby\"><code><span class=\"nb\">puts</span> <span class=\"s1\">'Hello world'</span></code></pre></div>}
      result.must_equal expected
    end

    it "renders a simple poem" do
      result = @markdown.render %Q{
```poem
She folds her warmth over mine.
Brush of hair, her neck inclines.
Ankles cross-uncross once more.
Tapered wrists twist to the floor.
A cold white glow winks in her hands.
Elbows flex and fingers dance.
}
      expected = %Q{<div class=\"poem\"><div class=\"body\"><p><span class=\"line\">She folds her warmth over mine.</span><br/><span class=\"line\">Brush of hair, her neck inclines.</span><br/><span class=\"line\">Ankles cross-uncross once more.</span><br/><span class=\"line\">Tapered wrists twist to the floor.</span><br/><span class=\"line\">A cold white glow winks in her hands.</span><br/><span class=\"line\">Elbows flex and fingers dance.</span><br/></p></div></div>}
      result.must_equal expected
    end

    it "renders poems with unclosed double smart quotes" do
      result = @markdown.render %Q{
```poem
She folds her warmth over mine.
Brush of hair, her neck inclines.
Ankles cross-uncross once more.
Tapered wrists twist to the floor.
A cold white glow winks in her hands.
Elbows flex and fingers dance.

``Yesss,'' she says, ``Another S!''
She's playing Words With Friends, I guess.
Oh, my sense of dignity!
I really wish she'd get off me.

``Babe'' she says, ``What ends with X---''
I vaguely hear, ``What ends with sex?''
Her voice continues distantly,
``---and has three letters and an E?''
``I don't know.'' Tex-Mex T-rex
Flecks specks pecks checks.
``How about *vex*?''
She tenses for an second now,
Intense activity, head bowed.
A brighter shade of night, a sound.
She slips and slithers, turns around,
Her hips and knees lock down my chest.
``Babe?'' she says, ``You are the best!''
She starts to move. ``Now your reward
``For the fifty points that I just scored.''
```
}

      expected = %Q{<div class=\"poem\"><div class=\"body\"><p><span class=\"line\">She folds her warmth over mine.</span><br/><span class=\"line\">Brush of hair, her neck inclines.</span><br/><span class=\"line\">Ankles cross-uncross once more.</span><br/><span class=\"line\">Tapered wrists twist to the floor.</span><br/><span class=\"line\">A cold white glow winks in her hands.</span><br/><span class=\"line\">Elbows flex and fingers dance.</span><br/></p><p><span class=\"line\">&ldquo;Yesss,&rdquo; she says, &ldquo;Another S!&rdquo;</span><br/><span class=\"line\">She&rsquo;s playing Words With Friends, I guess.</span><br/><span class=\"line\">Oh, my sense of dignity!</span><br/><span class=\"line\">I really wish she&rsquo;d get off me.</span><br/></p><p><span class=\"line\">&ldquo;Babe&rdquo; she says, &ldquo;What ends with X&mdash;&rdquo;</span><br/><span class=\"line\">I vaguely hear, &ldquo;What ends with sex?&rdquo;</span><br/><span class=\"line\">Her voice continues distantly,</span><br/><span class=\"line\">&ldquo;&mdash;and has three letters and an E?&rdquo;</span><br/><span class=\"line\">&ldquo;I don&rsquo;t know.&rdquo; Tex-Mex T-rex</span><br/><span class=\"line\">Flecks specks pecks checks.</span><br/><span class=\"line\">&ldquo;How about <em>vex</em>?&rdquo;</span><br/><span class=\"line\">She tenses for an second now,</span><br/><span class=\"line\">Intense activity, head bowed.</span><br/><span class=\"line\">A brighter shade of night, a sound.</span><br/><span class=\"line\">She slips and slithers, turns around,</span><br/><span class=\"line\">Her hips and knees lock down my chest.</span><br/><span class=\"line\">&ldquo;Babe?&rdquo; she says, &ldquo;You are the best!&rdquo;</span><br/><span class=\"line\">She starts to move. &ldquo;Now your reward</span><br/><span class=\"line\">&ldquo;For the fifty points that I just scored.&rdquo;</span><br/></p></div></div>}

      result.must_equal expected
    end

    it "renders poems with indentation" do
      result = @markdown.render %Q{
```poem
Ah, love,
        **sister**,
Falling, failing, fragile you.
You knocked on my door and
Told me it's been raining.
```
}
      expected = %Q{<div class=\"poem\"><div class=\"body\"><p><span class=\"line\">Ah, love,</span><br/><span class=\"line\">        <strong>sister</strong>,</span><br/><span class=\"line\">Falling, failing, fragile you.</span><br/><span class=\"line\">You knocked on my door and</span><br/><span class=\"line\">Told me it&rsquo;s been raining.</span><br/></p></div></div>}
      result.must_equal expected
    end

    it "renders 'em correctly" do
      result = @markdown.render %Q{
```poem
We send 'em to islands with disease and rapers
And if someone faked papers,
```
}
      expected = %Q{<div class=\"poem\"><div class=\"body\"><p><span class=\"line\">We send &rsquo;em to islands with disease and rapers</span><br/><span class=\"line\">And if someone faked papers,</span><br/></p></div></div>}
      result.must_equal expected
    end
  end
end
