class GoogleSearchController < ApplicationController
  sub_layout 'triple'
  
  def search
    text = params[:text]
    @cache_key = [:google, :search, text]
    unless fragment_exist? @cache_key
      GoogleAjax.referer = 'executter.com'
      @image_list = GoogleAjax::Search.images(text)
      @video_list = GoogleAjax::Search.video(text)
      @text_list = []
      #news_list  = GoogleAjax::Search.news(text)
      #web_list   = GoogleAjax::Search.web(text)
      #blog_list  = GoogleAjax::Search.blogs(text)
      GoogleAjax::Search.web(text)[:results].each do |web|
        @text_list << {:url=>web[:url],     :text=>web[:content]}
      end
      GoogleAjax::Search.news(text)[:results].each do |news|
        @text_list << {:url=>news[:url],      :text=>news[:title]}
      end
      GoogleAjax::Search.blogs(text)[:results].each do |blog|
        @text_list << {:url=>blog[:post_url], :text=>blog[:title]}
      end
      GoogleAjax::Search.books(text)[:results].each do |book|
        @text_list << {:url=>book[:url],      :text=>book[:title]}
      end
    end
  end

end
