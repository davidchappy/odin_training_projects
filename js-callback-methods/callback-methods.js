// http://www.theodinproject.com/courses/javascript-and-jquery/lessons/callbacks

// Callback exercises from:
// https://github.com/bgando/functionalJS/blob/master/callbacks/callbackExercises.md

var funcCaller = function(func, arg) {
  return func(arg);
}

// simple firstVal
var firstVal = function(arr, func) {
  func(arr[0], 0, arr);
}

// optional helper function (if we wanted to target only functions)
function getFunctions(object) {
  var functions = [];
  var keys = Object.keys(object);
  for(var i = 0; i < keys.length; i++) {
    if(typeof object[i] === 'function') {
      functions.push(keys[i]);
    }
  }
  return functions;
}

// refactored firstVal
var firstVal = function(collection, func) {
  if(Array.isArray(collection)) {
    func(arr[0], 0, arr);
  } else if (typeof collection === 'object') {
    // if we wanted to target only functions
      // var functions = getFunctions(collection);
      // func(functions[0], 0, collection);
    var keys = Object.keys(collection);
    func(keys[0], 0, collection);
  }
}

// write function that runs a target function only once
var once = function(func) {
  var alreadyCalled = false;
  return function() {
    if(!alreadyCalled) {
      alreadyCalled = true;
      func.apply(this, arguments);
    } else {
      console.log("Can only call once");
    }
  }
}

function log(string) {
  console.log(string);
}

var runLogger = once(log);

runLogger('calling the first time');
runLogger('trying to run the second time');


// Warmups
function myEach(array, callback) {
  for(var i = 0; i < array.length; i++) {
    callback(array[i]);
  }
};

myEach([1,2,3,4], function(item) {
  console.log(item);
});


function myMap(array, callback) {
  var newArray = [];
  for(var i = 0; i < array.length; i++) {
    newArray.push(callback(array[i]));
  }
  return newArray;
};

myMap([1,2,3,4], function(item) {
  console.log(item * 2);
  return item * 2;
});

console.log(myMap([1,2,3,4], function(item) {
  return item * 2;
}));

