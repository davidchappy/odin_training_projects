// elements
var $form = $('#mintSignupForm');

var fields = {
  email: $('#mintEmail'),
  emailConfirm: $('#mintEmailConfirm'),
  password: $('#mintPassword'),
  passwordConfirmation: $('#mintPasswordConfirm'),
  country: $('#mintCountry'),
  zip: $('#mintZip'),
  remember: $('#mintRemember'),
  submit: $('#submit')
}

// functions 
function validate(element) {
  if(element[0].type === 'email') {
    console.log("This is an email field");
  } else if(element[0].type === 'password') {
    console.log("This is a password field");
  } else if(element[0].type === 'text') {
    console.log("This is a text field");
  } else if(element.is('select')) {
    console.log("This is a select");
  } else {
    console.log(element[0]);
  }
}

function runValidations() {
  validate(fields.email);
  validate(fields.emailConfirm);
  validate(fields.password);
  validate(fields.passwordConfirmation);
  validate(fields.zip);
  validate(fields.country);
  validate(fields.submit);
}

function listen() {
  // tooltips
  console.log('listening');

  // class changes
}

$(document).ready(function() {
  listen();
  runValidations();
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