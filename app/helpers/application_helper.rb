module ApplicationHelper

  def yield_with_sub_layout(content)
    controller.sub_layout ? render(:layout => "layouts/#{controller.sub_layout}") { content } : content
  end

  def li(a)
    content_tag :li, a
  end

  def page_css_ref
    n1 = "c-#{controller.controller_name}"
    n2 = "a-#{controller.action_name}"
    n3 = cu_ro ? "logged-in" : "not-logged-in"
    "class='#{n1} #{n2} #{n3}'"
  end

  def bell_timeout
    Rails.env.production? ? 5000 : 196000
  end

  def background_image(user)
    raw "<style>body{background-image: url(#{user.theme.image.url}) !important;}</style>" if user.theme.image?
  end
  
  def bitly
    raw "<script>bitly();</script>" if MyF.production?
  end

end