$(document).ready(function() {
  // global/layout styles
  $(".nav li").css({
    "box-sizing": "border-box"
  });
  $("body").css({
    "margin": "0",
    "padding": "0"
  });
  $("#content").css({
    "width": "500px",
    "margin": "0 auto"
  });

  // Navigation
  $("body").prepend("<ul></ul>");
  $("body ul").addClass("nav");
  $(".nav").prepend("<li id='menu'><a href='#'>Menu</a></li>");
  $(".nav").prepend("<li id='contact'><a href='#'>Contact</a></li>");
  $(".nav").prepend("<li id='home' class='selected'><a href='#'>Home</a></li>");

  // nav styles
  $(".nav").css({
    "list-style": "none",
    "display": "block",
    "margin": "0 auto",
    "width": "500px",
    "text-align": "center"
  });

  $(".nav li").css({
    "list-style": "none",
    "display": "inline-block",
    "padding": "5px 15px",
    "width": "70px",
    "height": "30px",
    "line-height": "30px",
    "background": "#7D9F46",
    "border-radius": "5px",
    "margin": "0 5px",
    "color": "#fff",
    "text-align": "center",
    "cursor": "pointer"
  });

  $(".nav li").hover(function() {
    $(this).css({
      "box-shadow": "0 0 1px #2E2A23",
      "font-weight": "bold"
    }); 
  }, function() {
    $(this).css({
      "box-shadow": "none"
    });
  });

  $(".selected").css({
    "background": "#fff",
    "color": "#7D9F46",
    "border": "1px solid #7D9F46"
  });

  $(".nav a").css({
    "text-decoration": "none",
    "color": "inherit",
    "height": "100%",
    "width": "100%"
  });

  // nav bindings 
  $("body").on("click", "#home", function() {
    window.location.reload();
  });

  $("body").on("click", "#contact", function() {
    $("#content").html("<p>Get in touch!</p><p>Phone: 123-456-7890</p>");
  });

  $("body").on("click", "#menu", function() {
    $("#content").html("<p>The best choices!</p><p>Super Burger: $6.50</p><p>Yummy Pizza: $8.95</p><p>Mega Taco: $7.95</p>");
  });

  // Image
  $("<img src='https://s-media-cache-ak0.pinimg.com/originals/58/36/48/5836485b262104e35d3d69a4a05d3b35.jpg'>").insertBefore("#content") ;
  $("img").css({
    "height": "600",
    "max-width": "100%",
    "object-fit": "cover",
    "display": "block",
    "margin": "0 auto"
  });

  // Headline 
  $("#content").append("<h1>The Best Food in Town!</h1>");
  $("#content h1").css({
    "text-align": "center"
  })

  // Body copy
  $("#content").append("<p>Come find out what everyone's talking about!</p>");
  $("#content p").css({
    "text-align": "center"
  })
});