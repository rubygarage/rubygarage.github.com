$(function(){
  $('body').append('<div id="leoo_navigation"><ul id="leoo_list_links"> </ul><p id="leoo_menu">m</p></div>');

  $('#leoo_navigation').hover(function(){
  	$(this).stop().animate({width:"500px", height:"300px",left:"0px",bottom:"0px"}, 400);
    $('#leoo_list_links').css({'display':'block'});
    $('#leoo_menu').css({'display': 'none'});

    if($('#leoo_list_links').children().length <= 0){
      $.each($('.slide'), function(index, value){
        var title = $(this).find('h1').html();
        var link_class = 'link_h1';
        if(!title){
          title = $(this).find('h2').html();
          link_class = 'link_h2';
        }
        if(!title){
          title = $(this).find('h3').html();
          link_class = 'link_h3';
        }
        var id = $(this).attr("id");
        var link = '<a href="#'+id+'">#'+(index+1)+' '+title+' ('+id+')</a>';
        $('#leoo_list_links').append('<li class="'+link_class+'">'+link+'</li>');
      });
    }
  },
  function(){
    $(this).stop().animate({width:"45px",height:"45px",left:"0",bottom:"0"}, 400);
    $('#leoo_list_links').css({'display': 'none'});
    $('#leoo_menu').css({'display': 'block'});
  });
});