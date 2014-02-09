$(document).ready(function() {

  autocomplete();

  selectize();

  tags();


  var delay = (function(){
    var timer = 0;
    return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    };
  })();

  $('.live-search').on("keyup", function() {
    tag = $('#facets').data('tag');
    page = $('#facets').data('page');
    query = $(this).val();
    delay(function(){
      $.getScript( "reseau?search="+query+"&tag="+tag+"&page="+page );
    }, 500 );
  });
});