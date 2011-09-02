module ApplicationHelper

  def yield_with_sub_layout(content)
    controller.sub_layout ? render(:layout => "layouts/sub/#{controller.sub_layout}") { content } : content
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
    Rails.env.production? ? 500000 : 196000
  end

  def background_image(user)
    raw "<style>body{background-image: url(#{user.theme.image.url}) !important;}</style>" if user.theme.image?
  end
  
  def bitly
    raw "<img class='bitly' src='http://bit.ly/executter?#{Time.now.to_i}#{Random.rand}' style='display:none' />" if My.production?
  end

end
