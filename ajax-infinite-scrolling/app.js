var pageCount = 1;

function getAJAX(url, containerID, callback, targetID) {
  if(targetID) {
    url = url + ' #' + targetID;
    $('#' + containerID).load(url);
  } else {
    $.ajax({
      url: url,
      type: "GET",
      dataType: "json",
      beforeSend: function() {
        $("#" + containerID).append('<span id="loading">Loading...</span>');
      },      
      success: function(data) {
        console.log("success");
        $("#loading").remove();
        callback(data);
      },
      error: function(xhr, textStatus, errorThrown) {
        console.log("There was an error");
        console.log(xhr);
        $("#" + containerID).html('<p class="error">Oops there was an error: ' + xhr.statusText + '</p>');
      }    
    }); 
  };
};

function evalMovieQuery(json) {
  var query = 'http://www.omdbapi.com/?';
  // evaluate submitted title
  var title = $("#movieChooser").children('#movieTitle').val();
  if(title.length > 3) {
    title = "s=" + title;
  } else {
    return false;
  }
  // evaluate optional submitted year
  var year = $("#movieChooser").children('#movieYear').val();
  if(year) year = "\&y=" + year; 
  // build and return query string
  var page = "\&page=" + pageCount;
  var type = "\&r=" + "json";
  query += title + year + type + page;
  return query;
}

function getMovies(json) {
  $.each(json.Search, function(index, val) {
    $.ajax({
      url: 'http://www.omdbapi.com/?i=' + val.imdbID + "\&plot=short\&r=json",
      type: 'GET',
      dataType: 'json',
      success: function(json) {
        console.log(json);
        displayMovie(json);
      },
      error: function(xhr, error, status) {
        console.log(status);
        console.log(error);
      }
    });
  });
}

function displayMovie(movie) {
  var entry = $("<li class=movie></li>");
  if(movie.Poster && movie.Poster != 'N/A') {
    entry.append("<img class='poster' src='" + movie.Poster + "'>");
  };
  entry.append("<h3>" + movie.Title + "</h3>");
  entry.append("<p>Year: " + movie.Year + "</p>");
  // entry.append("<p>IMDB id: " + movie.imdbID + "</p>");
  entry.append("<p>Summary: " + movie.Plot + "</p>");
  $("#target").append(entry);
}

function listen() {
  $('body').on('click', '#loadMovies', function(event) {
    event.preventDefault();
    console.log("searching");
    $("#target").empty();
    var form = $("#movieChooser");
    var query = evalMovieQuery(form);
    if(query) {
      getAJAX(query, 'target', getMovies);
    } else {
      $("#target").append("Please type a valid title (3+ characters).").show();
    }
    pageCount += 1;
    return false;
  });

  

}

$(document).ready(function() {
  listen();
});

