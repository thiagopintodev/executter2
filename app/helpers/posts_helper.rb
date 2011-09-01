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
      next unless a = w.index('v=')
      b = w.index('&') || 0
      i,j = a+2, b-1
      keys << w[i..j]
    end
    keys
  end
  def youtube_links(array)
    return array.collect do |key|
      "<iframe width='425' height='349' src='http://www.youtube.com/embed/#{key}?rel=0' frameborder='0' allowfullscreen></iframe>"
    end
  end
  def youtube(body)
    Rails.env.development? ? [] : youtube_links( youtube_keys(body) )
  end

  def link_to_username(username, mention_helper=true)
    #random_id="mention-user-#{rand(99999999)}"
    #link_to("@#{username}", "/#{username}", :class=>:user, :id=>random_id)
    link_to "@#{username}", "/#{username}", {:class=>'username', :title=>"Ver Perfil de @#{username}"}
  end

  def link_to_username_mention(username)
    link_to "@#{username}", "/#{username}", {:class=>'username-mention', :title=>"Mencionar @#{username}"}
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
    r = s.split(/\s/).collect do |w|
      if w[0,1]==user_key
        a = w[1..-1]
        b = a[User::USERNAME_REGEX]
        c = a.gsub(b,'')
        #d = "@#{b}"
        #e = "/#{b}"
        #random_id="mention-user-#{rand(99999999)}"
        #"#{link_to(d, e, :class=>:user, :id=>random_id)}#{c}"
        "#{link_to_username(b)}#{c}"
      elsif w[0,1]==group_key
        a = w[1..-1]
        b = a[User::USERNAME_REGEX]
        c = a.gsub(b,'')
        d = "##{b}"
        e = "/s/#{b}"
        #link_to(w, "/s/#{a}", :class=>:hash_tag)
        "#{link_to(d, e, :class=>:group)}#{c}"
      elsif w[0,1]==city_key
        a = w[1..-1]
        b = a[City::LABEL_REGEX]
        c = a.gsub(b,'')
        d = "$#{b}"
        e = "/c/#{b}"
        #link_to(w, "/s/#{a}", :class=>:hash_tag)
        "#{link_to(d, e, :class=>:group)}#{c}"
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
