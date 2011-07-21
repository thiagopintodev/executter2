module UsersHelper

  def current_user_is_not_user
    !user_me?
  end

  def user_post_tabs_item(text, number, url, css_class)
    css_class = "icon-color #{css_class}"
    content = raw "#{text} #{content_tag :span, '', :class=>css_class} #{content_tag :strong, number}"
    content_tag :li, link_to(content, url)
  end

  def my_image_tag(url, o={:dimensions=>nil})
    o[:width], o[:height] = o[:dimensions], o[:dimensions] if o[:dimensions]
    image_tag url, o
  end

end
