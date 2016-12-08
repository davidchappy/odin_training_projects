// elements
var $form = $('#mintSignupForm');

var fields = {
  email: {
    tag: $('#mintEmail'),
    requiredMessage: "Please enter email address"
  },
  emailConfirm: {
    tag: $('#mintEmailConfirm'),
  },
  password: {
    tag: $('#mintPassword'),
  },
  passwordConfirmation: {
    tag: $('#mintPasswordConfirm'),
  },
  country: {
    tag: $('#mintCountry'),
  },
  zip: {
    tag: $('#mintZip'),
    requiredMessage: "Please enter a valid zip code"
  },
  remember: {
    tag: $('#mintRemember'),
  },
  submit: {
    tag: $('#submit'),
  }
}

// validations 

// http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
function validEmail(email) {
  var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if(email) return re.test(email);
}

function hasCase(value) {
  var hasUpperCase = false;
  var hasLowerCase = false;
  for(var i=0; i<value.length; i++) {
    if(value[i] === value[i].toUpperCase()) {
      hasUpperCase = true;
    }
    if(value[i] === value[i].toLowerCase()) {
      hasLowerCase = true;
    }
  }
  if(value && hasLowerCase && hasUpperCase) {
    return true;
  } else {
    return false;
  }
}

function hasNumber(value) {
  for(var i=0; i<value.length; i++) {
    if(!isNaN(parseFloat(value[i])) && isFinite(value[i])) {
      return true;
    };
  }
  return false;
}

function hasSymbol(value) {
  var symbols = ["(", ")", "`", "~", "!", "@", "#", "$", "%", "^", "&", "*", "-", "+", "=", "|", "\\", "{", "}", "[", "]", ":", ";", "<", ">", ".", "?", "/"];
  for(var i=0; i<value.length; i++) {
    if(symbols.contains(value[i])) {
      return true;
    };
  }
  return false;
}


// Main functions
function validate(element) {
  element.errors = [];
  // Remove Browser's default validation message;
  element.validationMessage = null;
  
  // Gets the DOM element
  var htmlTag = element.tag[0];

  // Validate presence
  if(htmlTag.required && htmlTag.value === '' && element.requiredMessage) {
    element.errors.push(element.requiredMessage);
  } 

  if(htmlTag.type === 'email') {
    if(htmlTag.id === 'mintEmailConfirm' 
      && htmlTag.value != fields.email.tag[0].value) {
      element.errors.push('Confirm email field does not match the email address field.')
    } else if (htmlTag.id === 'mintEmail' && !validEmail(htmlTag.value)) {
      element.errors.push('Please enter a valid email address');
    }
  } else if(htmlTag.type === 'password') {
    if(htmlTag.id === 'mintPassword') {
      if(htmlTag.value.length < 8) {
        element.errors.push('Use 8 or more characters');
      }
      if(!hasNumber(htmlTag.value)) {
        element.errors.push('Use upper and lower case letters (e.g. Aa)');
      }
      if(!hasCase(htmlTag.value)) {
        element.errors.push('Use a number (e.g. 1234)');
      }
      if(!hasSymbol(htmlTag.value)) {
        element.errors.push('Use a symbol (e.g. !@#$)');
      }
    } else if(htmlTag.id === 'mintPasswordConfirm' 
      && htmlTag.value != fields.password.tag[0].value) {
      element.errors.push('Confirm password field does not match the password field.')
    }
  } else {
    console.log(htmlTag);
  }

  var errors = element.errors;
  if(errors.length) {
    element.tag.addClass('has-errors');
    var list = element.tag.next('ul');
    if(errors.length > 1) list.addClass('multiple');
    $.each(errors, function(index, val) {
      var li = $('<li>' + val + '</li>');
      list.append(li);
    });
    list.show();
  }
}

function setup() {
  $.each(fields, function(index, element) {
    element.tag.after("<ul class='errors'></ul>");    
  });
}

function listen() {
  console.log('listening');

  // tooltips
  
}

// testing only
// function runValidations() {
//   validate(fields.email);
//   validate(fields.emailConfirm);
//   validate(fields.password);
//   validate(fields.passwordConfirmation);
//   validate(fields.zip);
//   validate(fields.country);
//   validate(fields.submit);
// }

$(document).ready(function() {
  setup();
  listen();

  // testing only
  // runValidations();
});





// jQuery Validation Plugin

// $('#mintSignupForm').validate({
//   rules: {
//     mintEmail: {
//       minlength: 5
//     },
//     mintEmailConfirm: {
//       minlength: 5,
//       equalTo: '#mintEmail'
//     },
//     mintPassword: {
//       minlength: 5
//     },
//     mintPasswordConfirm: {
//       minlength: 5,
//       equalTo: '#mintPassword'
//     } 
//   }
// });