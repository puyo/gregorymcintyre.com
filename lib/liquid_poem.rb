require 'liquid'

module LiquidPoem
  def self.lined_paragraphs(input)
    input.strip.split(/\n\n/).map do |paragraph|
      "<p>#{lines(paragraph)}</p>"
    end.join
  end

  def self.lines(input)
    input.split(/\n/).map do |line|
      %{<span class="line">#{line}</span><br/>}
    end.join
  end

  class PoemTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      @author = markup
      super
    end

    def render(context)
      %{<div class="poem"><div class="body">#{LiquidPoem.lined_paragraphs(super)}</div></div>}
    end
  end
end

Liquid::Template.register_tag('poem', LiquidPoem::PoemTag)

if $0 == __FILE__
  require 'minitest'
  require 'minitest/autorun'

  class TestLiquidPoem < MiniTest::Test
    def test_lines
      input = "A\nB\nC"
      expected = "<span class=\"line\">A</span><br/><span class=\"line\">B</span><br/><span class=\"line\">C</span><br/>"
      assert_equal(expected, LiquidPoem.lines(input))
    end

    def test_lined_paragraphs
      input = "A\nB\n\nC\nD"
      expected ="<p><span class=\"line\">A</span><br/><span class=\"line\">B</span><br/></p>" +
        "<p><span class=\"line\">C</span><br/><span class=\"line\">D</span><br/></p>"
      assert_equal(expected, LiquidPoem.lined_paragraphs(input))
    end
  end
end
