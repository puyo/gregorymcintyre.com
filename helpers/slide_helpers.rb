module SlideHelpers
  def markdown_slide(&block)
    if block_given?
      concat_content "<section data-markdown><textarea data-template>".html_safe
      concat_content capture_html(&block)
      concat_content "</textarea></section>".html_safe
    end
  end
end
