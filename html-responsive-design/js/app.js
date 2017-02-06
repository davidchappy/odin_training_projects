jQuery(document).ready(function($) {
  $('.navigation').on('click', '#nav-trigger', function(event) {
    $('.mob-nav').css('display', 'block');
  });
  $('header').on('click', '#close-nav', function(event) {
    $('.mob-nav').css('display', 'none');
  });
});