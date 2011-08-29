module GoogleHelper

  def google_ads
    return '' if Rails.env.development?
    raw '<script type="text/javascript"><!--
google_ad_client = "ca-pub-6584941372808114";
/* ex2a */
google_ad_slot = "0497371180";
google_ad_width = 200;
google_ad_height = 200;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>'
  end

  def google_analytics
    return '' if Rails.env.development?
    raw "<script type='text/javascript'>
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-15228139-2']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>"
  end

end
