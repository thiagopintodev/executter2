mention_username=false;

function bitly() {
  $('.bitly').remove();
  $('body').append("<img class='bitly' src='http://bit.ly/executter' style='display:none' />");
}

function make_colorbox() {
  $("a[rel='thumbnail']").colorbox({transition:"elastic", speed: 500});
}
function make_button() {
  $('.ui-button').button();
}
function mention(username) {
  $('#home-form-tabs textarea:visible').append(username+' ').focus();
}
function get_notifications_url() {
  return '/h/ajax_notifications?time='+new Date().getTime();
}
function load_post_news_button() {
  $("#home-news-holder").load('/h/ajax_news_button');
}
function registerContextMenu() {
/*
  var list = $("a.user[data-menucontext!=1]");
  if (list.length > 0) {
    menu = new ContextMenu();
    menu.addItem( "mention",
                  "Mention",
                  functions.application.cmenu.mention,
                  "/stylesheets/ContextMenu-Images/page_white_copy.png"
                  );
    menu.addItem( "redirect",
                  "Profile",
                  functions.application.cmenu.redirect,
                  "/stylesheets/ContextMenu-Images/paste_plain.png"
                  );
    $("a.user[data-menucontext!=1]").each(function() {
      menu.register($(this).attr('id'));
      $(this).attr('data-menucontext',1);
    });
  }
*/
}
$(function() {

  $title = $("head title").html();
  $title1 = $title;
  $title2 = $title;
  $title_at1 = true;
  
  setInterval(function() {
    t = ($title_at1) ? $title1 : $title2;
    $title_at1 = !$title_at1;
    $("head title").html(t);
  }, 1200);

  functions.application.ex2tabs.append_behaviour();
  functions.application.ajaxload.run();
  functions.application.search.append_behaviour();

  setTimeout(function() {
  functions.application.notification.append_behaviour();
  }, 5000);
  
  make_button();
  functions.application.css2.fix();
  //registerContextMenu();
  make_colorbox();

  $('a.username-mention').live('click', function () {
    if (CONTROLLER=='home')
      mention($(this).html());
    else
      window.location='/?mention='+$(this).html();
    return false;
  });
  

  $(".tabs").tabs().find("*").removeClass("ui-widget-header ui-corner-all");
  $('.restrict_name').keyup(function () { 
    for (var i=0; i<this.value.length; i++)
      this.value = this.value.replace(/([0-9\^<,@\/\{\}\(\)\*\$%\?=>:\|;#]+)/i,'');
  });
  $('.restrict_username').keyup(function () { 
    for (var i=0; i<this.value.length; i++)
      this.value = this.value.replace(/[^a-zA-Z0-9_-]/,'');
  });

  $("div.anchor").live('click', function() {
    window.location = $(this).attr('href');
    return false;
  });
  
});
