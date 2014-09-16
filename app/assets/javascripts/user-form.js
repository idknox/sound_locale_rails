$('.input-error').hide();

var inputs = $(".user-form :input");

var isValid = function (input) {
  return (input.val() != '')
};

inputs.on('blur', function () {
  if (isValid($(this))) {
    $(this).removeClass('invalid');
    $(this).siblings('.input-error').hide();
  } else {
    $(this).addClass('invalid');
    $(this).siblings('.input-error').show();
  }
});

