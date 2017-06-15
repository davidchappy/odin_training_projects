// Setting up our variables
var $container = $('#container');
var output = '';
var blockCount = 1024;
var colorClass = 'blue';
var selectedInput = '';

//Looping through divs and outputting to page
for (i=0; i<blockCount; i++) {
  output += '<div class="block"></div>';
}
$container.html(output);
var $blocks = $(".block");

//Paint blocks
function colorBlocks(target, inputType) {
  $(target).on(inputType, function() {
    $(target).addClass(colorClass);
  });
}
$blocks.each(function() {
  colorBlocks($(this), selectedInput);
});

//Choose color with buttons (blue is default)
var $colors = $(".colors").children();
$colors.each(function() {
  $(this).click(function() {
    colorClass = $(this).html().toLowerCase();
  });
});

//Toggle input type
$inputButtons = $('.input-types').children();
$inputButtons.each(function() {
  $(this).click(function() {
   $(this).siblings().removeClass('selected-input');
   $(this).addClass('selected-input');
   selectedInput = $(this).attr('id');
   console.log(selectedInput);
   colorBlocks($(blocks).each, selectedInput); 
  });
});

//Reset button
$("#reset-btn").click(function() {
   $blocks.each(function() {
      $(this).removeClass('blue');
      $(this).removeClass('red');
      $(this).removeClass('green');
    });
});