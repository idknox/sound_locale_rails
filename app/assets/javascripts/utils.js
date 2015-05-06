window.utils = {
  isHidden: function (el) {
    var display = el.css('display');
    return (display === 'none')
  },

  toggleHeight: function (el, minHeight, maxHeight) {
    var targetHeight = (el.height() === minHeight) ? maxHeight : minHeight;

    el.animate({
      height: targetHeight
    }, 500)
  },

  endYoutubePlayer: function () {
    if (!this.isHidden($('#yt-player'))) {
      $('#yt-player').slideToggle();
      $('#yt-video').attr('src', '').css('height', 28);
    }
  },

  endSoundcloudPlayer: function () {
    if (!this.isHidden($('#sc-player'))) {
      $('#sc-player').slideToggle();
      $('#sc-widget').empty();
    }
  }
};

