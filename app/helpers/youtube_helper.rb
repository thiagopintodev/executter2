module YoutubeHelper

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
      image_tag "http://ytimg.googleusercontent.com/vi/#{key}/2.jpg", :class=>'youtube', :'data-youtube' => key
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

end
