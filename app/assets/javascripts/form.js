$('.input-error').hide();

var inputs = $(".user-form :input");

var isValid = function (input) {
  return (input.val() != '')
};

inputs.on('blur change keyup', function () {
  if (isValid($(this))) {
    $(this).removeClass('invalid');
    $(this).siblings('.input-error').hide();
  } else {
    $(this).addClass('invalid');
    $(this).siblings('.input-error').show();
  }
});

$('#user-password-confirmation').on('blur', function () {
  if ($(this).val() != $('#user_password').val()) {
    $(this).siblings('.input-error').empty();
    $(this).siblings('.input-error').append(' <- must match password');
    $(this).siblings('.input-error').show();

  }
});