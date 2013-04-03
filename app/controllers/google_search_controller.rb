class GoogleSearchController < ApplicationController
  sub_layout 'triple'
  
  def search
    begin
      redirect_to :root unless text = params[:text]
      @cache_key = [:google, :search, text]
      unless fragment_exist? @cache_key
        GoogleAjax.referer = 'executter.com'
        @image_list = GoogleAjax::Search.images(text)
        @video_list = GoogleAjax::Search.video(text)
        @text_list = []
        GoogleAjax::Search.web(text)[:results].each   { |r| @text_list << {:url=>r[:url],       :text=>r[:content]}  }
        GoogleAjax::Search.news(text)[:results].each  { |r| @text_list << {:url=>r[:url],       :text=>r[:title]}    }
        GoogleAjax::Search.blogs(text)[:results].each { |r| @text_list << {:url=>r[:post_url],  :text=>r[:title]}    }
        GoogleAjax::Search.books(text)[:results].each { |r| @text_list << {:url=>r[:url],       :text=>r[:title]}    }
      end
    rescue
      redirect_to :root
    end
  end

end
