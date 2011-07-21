module EditHelper

  def sidebar_edit_link_list(text, url, css_class)
    css_class = "icon-color #{css_class}"
    
    content = raw "#{text} #{content_tag :span, '', :class=>css_class}"
    anchor = link_to content, url
    content_tag :li, anchor
  end

end
