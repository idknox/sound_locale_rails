$(function () {
  $('.cal-date').datepicker({ dateFormat: "yy-mm-dd"});
});

$('.cal-date').datepicker({
  onSelect: function (dateText) {
    dateText = dateText.toString().replace('/', '').replace('/', '');
    $('html,body').animate({
      scrollTop: $('#' + dateText + '').offset().top
    }, 500);
//    dateText = dateText.toString().replace('/', '').replace('/', '');
//    $('.event-date-container').hide();
//    $('#' + dateText + '').show();
  }
});