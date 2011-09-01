module PostsHelper

  def can_comment?(post)
    !post.repost? and current_user
  end

  def post_get_comments(post)
    limit = controller.controller_name=='post' ? 50 : 3
    post.post ? [post.post] : post.posts.limit(limit).order("ID desc").reverse
  end

  def page_post_show?
    controller.controller_name=='posts'
  end

  def post_actions_link(text, url, css_class, options={})
    css_class = "icon-color #{css_class}"
    
    content = raw "#{text} #{content_tag :span, '', :class=>css_class}"
    link_to content, url, options
  end

  def youtube_keys(string)
    return [] unless string.index('youtube')
    keys = []
    string.split(/\s/).collect do |w|
      next unless w.index('youtube')
      next unless a = w.index('v=') || w.index('v/')
      b = w.index('&') || 0
      i,j = a+2, b-1
      keys << w[i..j]
    end
    keys
  end
  def youtube_links(array)
    return array.collect do |key|
      "<object width='425' height='349'><param name='movie' value='http://www.youtube.com/v/#{key}?version=3&amp;hl=pt_BR&amp;rel=0'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><param name='wmode' value='transparent'><embed src='http://www.youtube.com/v/#{key}?version=3&amp;hl=pt_BR&amp;rel=0' type='application/x-shockwave-flash' width='425' height='349' allowscriptaccess='always' allowfullscreen='true' wmode='transparent'></embed></object>"
    end
  end
  def youtube_links_210(array)
    return array.collect do |key|
      "<object width='210' height='170'><param name='movie' value='http://www.youtube.com/v/#{key}?version=3&amp;hl=pt_BR&amp;rel=0'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><param name='wmode' value='transparent'><embed src='http://www.youtube.com/v/#{key}?version=3&amp;hl=pt_BR&amp;rel=0' type='application/x-shockwave-flash' width='210' height='170' allowscriptaccess='always' allowfullscreen='true' wmode='transparent'></embed></object>"
    end
  end
  def youtube(body)
    Rails.env.development? ? [] : youtube_links( youtube_keys(body) )
  end
  def youtube_210(body)
    Rails.env.development? ? [] : youtube_links_210( youtube_keys(body) )
  end

  def link_to_username(username, mention_helper=true)
    username = username.downcase
    #random_id="mention-user-#{rand(99999999)}"
    #link_to("@#{username}", "/#{username}", :class=>:user, :id=>random_id)
    url = @mobile ? "/m/u/#{username}" : "/#{username}"
    link_to "@#{username}", url, {:class=>'username', :title=>"Ver Perfil de @#{username}"}
  end

  def link_to_username_mention(username)
    url = @mobile ? "/m/u/#{username}" : "/#{username}"
    link_to "@#{username}", url, {:class=>'username-mention', :title=>"Mencionar @#{username}"}
  end

  def link_to_search(title)
    #url = @mobile ? "/m/s/#{username}" : "/s/#{title}"
    url = "/s/#{title}"
    link_to "##{title}", url, :class=>:search
  end
  
  def link_to_city(label)
    #url = @mobile ? "/m/c/#{label}" : "/c/#{label}"
    url = "/c/#{label}"
    link_to "$#{label}", url, :class=>:city
  end
  
  def link_to_google_search(text)
    #url = @mobile ? "/m/c/#{text}" : "/c/#{text}"
    url = "/google_search/#{text}"
    link_to "!#{text}", url, :class=>:google
  end
  
=begin
w.starts_with?('www')
w: '@username...'
a: 'username...'
b: 'username'
c: '...'
d: '@username'
e: '/username'
=end
  def my_post_links(s)
    s = s.gsub("\r"," ")
    user_key = "@"
    group_key = "#"
    city_key = "$"
    google_search_key = "!"
    r = s.split(/\s/).collect do |w|
      if w[0,1]==user_key
        a = w[1..-1]
        b = a[User::USERNAME_REGEX]
        c = a.gsub(b,'')
        "#{link_to_username(b)}#{c}"
      elsif w[0,1]==group_key
        a = w[1..-1]
        b = a[User::USERNAME_REGEX]
        c = a.gsub(b,'')
        "#{link_to_search(b)}#{c}"
      elsif w[0,1]==city_key
        a = w[1..-1]
        b = a[City::LABEL_REGEX]
        c = a.gsub(b,'')
        "#{link_to_city(b)}#{c}"
      elsif w[0,1]==google_search_key
        a = w[1..-1]
        b = a[City::LABEL_REGEX]
        #c = a.gsub(b,'')
        #"#{link_to_google_search(b)}#{c}"
        "#{link_to_google_search(b)}"
      elsif w[0..2] == 'www' || w[0..6]=='http://' || w[0..5]=='ftp://' || w[0..7]=='https://'
        w2 = "http://#{w}" if w[0..2] == 'www'
        link_to w, w2||w, :target=>'_blank'
      else
        w
      end
    end
    raw r.join(" ")
  end
end
