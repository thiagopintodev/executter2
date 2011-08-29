module Col2Helper

  def col2_google_ads
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

end
