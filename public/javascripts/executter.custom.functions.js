live_array = [];

functions = {}

functions.application = {}

functions.application.search = {}
functions.application.search.append_behaviour = function() {

  $('#text').live('keypress', function(e) {
    if(e.keyCode == 13) {
      url = '/s/'+$('#text').val();
      window.location = url;
      return false;
    }
  });
  $('#search').live('click', function() {
    var val = $('#text').val();
    var url = '/s/'+encodeURI(val).replace('/',' ');
    window.location = url;
    return false;
  });

}




functions.registration = {}

functions.registration.ajax = {}
functions.registration.ajax.append_behaviour = function() {
  $("#user_city_base_id").tokenInput("/cities/base_search.json", {tokenLimit: 1});
}

/*
functions.application.cmenu = {}
functions.application.cmenu.mention = function(e) {
  var username = $(e.target).html();
  if (CONTROLLER=='home')
    mention(username);
  else
    window.location='/?mention='+username;
  return false;
}
functions.application.cmenu.redirect = function(e) {
  var username = $(e.target).html();
  window.location='/'+username;
}
functions.application.cmenu.redirect_new = function(e) {
  //var username = $(e.target).html();
  x=e;
  $(e.target).attr('target','_blank');
  $(e.target).click();
  //$("<a href='/"+username+"' target='_blank'></a>").click();
}
*/
functions.application.css2 = {}
functions.application.css2.fix = function() {

  /*t2gs css2 fix*/
  $("select").addClass("input-value input-type-select");
  $("input[type='text'], textarea").addClass("input-value input-type-text");
  $("input[type='password']").addClass("input-value input-type-text input-type-password");
  
  $("input[type='button']").addClass("input-button input-type-button");
  $("input[type='image']").addClass("input-button input-type-image");
  $("input[type='submit']").addClass("input-button input-type-submit");

  
  $("input[type='checkbox']").addClass("input-value input-type-checkbox");
  $("input[type='radio']").addClass("input-value input-type-radio");
  
  $("input[type='checkbox']").live('change', function() {
    if ($(this).nodeName == "LABEL") {
      label = $(this);
      checkbox = $("#"+$(this).attr('for'));
    } else {
      checkbox = $(this);
      label = $("label[for='"+$(this).attr('id')+"']");
    }
    if (checkbox.attr('checked')) {
      checkbox.addClass('input-type-checkbox-checked');
      label.addClass('checked');
    } else {
      checkbox.removeClass('input-type-checkbox-checked');
      label.removeClass('checked');
    }
  });
  
  $("input[type='radio']").live('change', function() {
    $("input[type='radio']").each(function(index, element){
      lbl = $("label[for='"+$(this).attr('id')+"']");
      if ($(this).attr('checked')) {
        $(this).addClass('input-type-radio-checked');
        lbl.addClass('checked');
      } else {
       $(this).removeClass('input-type-radio-checked');
        lbl.removeClass('checked');
      }
    });
  });

  $("li, .post, div.anchor").live('mouseover mouseout', function(e) {
    if (e.type=="mouseout")
      $(this).removeClass('hover');
    else
      $(this).addClass('hover');
  });
}


functions.application.notification = {}
functions.application.notification.append_behaviour = function() {

  if ($('#bell').size() == 0)
    return;
  
  $('#bell').live('click', function() {
    if ($(this).hasClass('selected')) {
      $('#bell').removeClass('selected');
      $('#bellbox').hide();
    } else {
      $('#bell').addClass('selected');
      $('#bellbox').show();
      if ($(this).attr('mark-all-as-read')!='1' && $(this).html()) {
        $(this).attr('mark-all-as-read', '1');
        $(this).html('');
        $.post('/h/mark_notifications_as_read');
        $title2 = $title;
      }
    }
    return false;
  });
  $("body").live('click', function(e) {
    $('#bell').removeClass('selected');
    $('#bellbox').hide();
  });

  var notifications_delay = RAILS_ENV=='production' ? 15000 : 60000;

  $('#bell').show();
  $('#bellbox').load( get_notifications_url() );
  setInterval(function() {
    //
    $('#bellbox').load( get_notifications_url() );
    //
  }, notifications_delay);
}

functions.text = {}
functions.text.format_mentions = function(unformated_text) {
  return unformated_text;
  var i=0;
  var a=unformated_text.split(' ');
  var result = '';
  for (i=0;i<a.length;i++)
  {
    t = a[i];
    if (t[0]=='@')
    {
      //alert(t);
      var u = t.substring(1, t.length);
      a[i] = "<a href='/"+u+"'>"+t+"</a>";
    }
  }
  return a.join(' ');

}


functions.application.ex2tabs = {}
functions.application.ex2tabs.append_behaviour = function() {

  $("ul.ex2tabs a").live('click', function() {
    $("div.ex2tabs").html("<p class='in'>carregando...</p>");

    /* nice css adding */
    $("ul.ex2tabs a, ul.ex2tabs a *").removeClass('selected');
    $(this).addClass('selected').contents().addClass('selected');
    
    var url = $(this).attr('href');
    
    $.ajax({
      url: url,
      error: function( xhr, status, index, anchor ) {
	      $("div.ex2tabs").html("<p class='in'>Erro ao carregar esta aba.</p>");
      },
      success: function(returnedHtml) {
        $("div.ex2tabs").html( functions.text.format_mentions(returnedHtml) );
      }
    });

    
    return false;
  });
  $("ul.ex2tabs.list a:first").click();

}

functions.application.ajaxload = {}
functions.application.ajaxload.run = function(e) {

  $("[data-ajaxload-event='click']").live("click", functions.application.ajaxload.load_element);
  $("[data-ajaxload-event='load']").each(function(){
    functions.application.ajaxload.load_element(this);
  });
  
}
functions.application.ajaxload.load_element = function(e) {
  var url       = $(e).data('ajaxload-url'),
      nocache   = $(e).data('ajaxload-nocache'),
      target    = $(e).data('ajaxload-target'),
      timeout   = $(e).data('ajaxload-timeout'),
      interval  = $(e).data('ajaxload-interval');

  if (!url)
    url = $(e).attr('href');

  if (nocache)
      url += '?time='+new Date().getTime();

//alert(target+' -> '+url);

  if (timeout)
    setTimeout($(target).load, timeout, url);
  else
    $(target).load(url);
  
  if (interval)
    setInterval($(target).load, interval, url);
  return false;
}

functions.application.autoload = {}
functions.application.autoload.load = function(item) {
  alert('functions.application.autoload.load deprecated');
}
functions.application.autoload.run = function() {
  alert('functions.application.autoload.run deprecated');
}


functions.home = {}
functions.home.ajax = {}
functions.home.ajax.append_behaviour = function() {

  $("#home-form-tabs input[type='submit']").button();

  $("#home-form-tabs").tabs().show().find("*").removeClass("ui-widget-header ui-corner-all");
  $("#home-post-tabs").tabs().show().find("*").removeClass("ui-widget-header ui-corner-all");
  
  //after submit
  $('form.new_topic').ajaxForm(function() {
    $("#home-form-tabs-holder").load( $("#home-form-tabs-holder").data('ajaxload-url') );
    functions.home.ajax.load_latest_posts_main_tab();
    $.get('/p/generate_notifications');
  });

  functions.home.ajax.append_behaviour_once();
}
functions.home.ajax.append_behaviour_once = function() {
  if (live_array['functions.home.ajax.append_behaviour_once'])
    return false;
  live_array['functions.home.ajax.append_behaviour_once'] = true;


  $("#home-form-tabs").live('tabsselect', function(event, ui) {
    $("#home-form-tabs ul li a span").removeClass('selected');
    $(ui.tab).find('span').addClass('selected');
    var old = "";
    $("#home-form-tabs textarea").each(function() {
      if ($(this).val()) {
        old = $(this).val();
        $(this).val('');
      }
    });
    var ta = $(ui.panel).find('textarea');
    if (old) {
      ta.val(old);
      ta.trigger('keydown');
    }
  });
  
  $('.new_topic textarea').live('keydown', function(e) {
    if (e.ctrlKey && e.keyCode==13)
      $(this).closest('form').submit();
    else {
      var dif = 196-$(this).val().length;
      $(this).closest('form').find('.chars').html( dif );
      if (dif >= 0)
        $(this).val( $(this).val().substring(0,196) );
    }
  });

  //before submit
  $('form.new_topic').live('submit', function(){
    $("#home-form-tabs input[type='submit']").replaceWith("<img style='float:right' src='/images/ajax_new_post.gif'/>");
  });


  $("#home-post-tabs").live('tabsselect tabscreate', function(event, ui) {
      $(ui.panel).html("<center><img style='margin-top:100px;' src='/images/tab-panel-loading.gif' /></center>");
  });

  $("#home-news-holder a").live('click', function() {
    functions.home.ajax.load_latest_posts_main_tab();    
    return false;
  });
  
  setTimeout(load_post_news_button,   5000);
  setInterval(load_post_news_button, 45000);
}
functions.home.ajax.load_latest_posts_main_tab = function() {
  setTimeout(function() {
    //
    $("#home-news-holder a").remove();
    $title1 = $title;
    $("#home-post-tabs").tabs('select', 0);
    $.get('/h/posts_followings_all_latest', function(data) {
      $("#home-post-tabs .ui-tabs-panel:first").prepend(data);
    });
    //
  }, 1);
}

functions.profile = {}
functions.profile.ajax = {}
functions.profile.ajax.append_behaviour = function() {

  $('.relate_panel .do_it').live('click', function() {
    $('.relate_panel').html('');
    return false;
  });

}

functions.posts = {}
functions.posts.more = {}
functions.posts.more.append_behaviour = function() {

  $('.more').live('click', function() {
    var t =  $(this);
    var url = t.data('url');
    t.html('').attr('class','');
    
    $.ajax({
      url: url,
      success: function(returnedHtml) {
        t.replaceWith( functions.text.format_mentions(returnedHtml) );
      }
    });
    return false;
  });

}
functions.posts.ajax = {}
functions.posts.ajax.append_behaviour = function() {

  $('.like_it').live('click', function() {
    $(this).replaceWith('<strong>Liked it<strong>');
    return false;
  });
  $("form.new_comment").live('submit', function() {
    post = $(this).closest('.post');
    post.contents().find('.toggle_comment').remove();
    post.contents().find('.comment-state-before, .comment-state-during').hide();
    $(post.data('comments-target')).load(post.data('comments-url'), function() {
      post.contents().find('.comment-state-during textarea').val('');
      post.contents().find('.comment-state-during').show();
      post.contents().find('.comment-state-during textarea').focus();
    });
  });

  $("a[rel='post-comments-loader']").live('click', function () {
    var url = $(this).data('url');
    var target = $(this).data('target');
    $(target).load(url);
    $(this).closest('.info').fadeOut();
    return false;
  });
  /*
  $("form.new_post").live('submit', function() {
    $(this).contents().find('textarea').val('');
    
    //$(this).contents().find('input:submit').parent().append('<strong>YOU POSTED IT</strong>');
  });
*/


  
  $('.post a.delete-post').live('click', function() {
    $(this).closest('.post').slideToggle("fast");
    return false;
  });
  $('.post a.delete-comment').live('click', function() {
    $(this).closest('.comment').slideToggle("fast");
    return false;
  });

  
  $('.toggle_comment').live('click', function() {
    $(this).closest('.post').find('.comment:last .comment-state-before').hide();
    $(this).closest('.post').find('.comment:last').show()
                          .find('.comment-state-during').show()
                          .find('textarea').focus();
    return false;
  });
  $('.post .comment-state-before textarea').live('focus', function() {
    $(this).closest('.comment').find('.comment-state-before').hide();
    $(this).closest('.comment').find('.comment-state-during').show().find('textarea').focus();
    return false;
  });
  $('.post .comment-state-during textarea').live('keypress', function(e) {
    if(e.keyCode == 13) {
      $(this).closest('.comment-state-during').hide();
      $(this).closest('form').submit();
    }
  });
  

}

