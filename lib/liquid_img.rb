require 'liquid'

class ImageTag < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    @img = nil
    attributes = ['class', 'src', 'width', 'height', 'title']
    if markup =~ /(?<class>\S.*\s+)?(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?(?<title>\s+.+)?/i
      @img = attributes.reduce({}) { |img, attr| img[attr] = $~[attr].strip if $~[attr]; img }
      if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ @img['title']
        @img['title']  = title
        @img['alt']    = alt
      else
        @img['alt']    = @img['title'].gsub!(/"/, '&#34;') if @img['title']
      end
      @img['class'].gsub!(/"/, '') if @img['class']
    end
    super
  end

  def render(context)
    if @img
      "<img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>"
    else
      "Error processing input, expected syntax: {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
    end
  end
end

Liquid::Template.register_tag('img', ImageTag)
