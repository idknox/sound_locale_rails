window.eventUi = {
  displayGrid: function () {
    $('.events-list, .toggle-all').hide();
    $('.grid-container, .grid-instructions').show();
    localStorage['eventView'] = 'grid';
  },

  displayList: function () {
    $('.grid-container, .grid-instructions').hide();
    $('.events-list, .toggle-all').show();
    localStorage['eventView'] = 'list';
  },

  displayAll: function () {
    $('.date-content, #close-all').show();
    $('#expand-all').hide();
    this.stickyDate = true;
  },

  displayFiltered: function () {
    eventUi.displayList();
    $('.date-content').show();
    $('.toggle-all').hide();
    $('.expand').empty().append('\u00a0');
    this.stickyDate = false;
  },

  closeAll: function () {
    $('.date-content, #close-all').hide();
    $('#expand-all').show();
    this.stickyDate = false;
  },

  loadAllEvents: function () {
    var headers = $('.date-header');
    localStorage.clear();
    headers.each(function () {
      var header = $(this)
      eventUi.fillDate(header)
    });

//    var today = $('.date-header').first().siblings('.date-content');
//    eventUi.fillDate($('.date-header').first())
//    today.slideToggle();
    $('.date-content').slideToggle();
  },

  fillDate: function (header) {
    var content = header.siblings('.date-content');
    var headerDate = header.data('date');
    var storedEvents = localStorage.getItem(headerDate);

    if (!storedEvents) {
      $.get('/events/date/' + headerDate, {}, function (events) {
        $.each(events, function (i, event) {
          var opener = event.opener || '';
          var time = moment(event.time);
          var formatted_time = time.format('h:mma');

          var event = '<div class="event clear"><div class="col-xs-12 col-md-5 title">' +
            '<div class="headliner">' + event.headliner + '</div>' +
            '<div class="opener">' + opener + '</div></div><div class="col-xs-12 ' +
            'col-md-5 info">' + formatted_time + ' @ <a href="/venues/' + event.venue.id +
            '" class="body-link">' + event.venue.name + '</a><div class="price">' +
            event.price + '</div></div><div class="col-xs-12 col-md-2 links">' +
            '<div class="row"><div class="col-xs-3"><a class="tickets-trigger" href="' + event.tickets + '"><i class="fa fa-ticket ' +
            '"></i></a></div><div class="col-xs-3">' +
            '<i class="fa fa-map-marker map-trigger" data-event-id="' + event.id +
            '"></i></div><div class="col-xs-3"><i class="fa fa-youtube-play yt-trigger"' +
            'data-query="' + event.headliner + '"></i></div><div class="col-xs-3"><i class="fa fa-soundcloud sc-trigger" ' +
            'data-scUrl="' + event.soundcloud_url + '"></i></div></div></div></div></div>';

          content.append(event);
        });
        var eventString = content.innerHTML;
        localStorage.setItem(headerDate, eventString);
        eventUi.showScButtons(content)
      });
    } else {
      var eventString = localStorage.getItem(headerDate);
      content.append(eventString);
      eventUi.showScButtons(content)
    }
  },

  expandDate: function (header) {

    var menuHeight = $('#nav-custom').height();
    var content = header.siblings('.date-content');

    $('html,body').animate({
      scrollTop: header.offset().top - menuHeight
    }, 500);
    content.slideToggle();
  },

  showScButtons: function (content) {
    content.find('.sc-trigger').each(function () {
      var trigger = $(this);
      var url = trigger.data('scurl');
      if (url !== '' && url !== 'null') {
        trigger.show();
      }
    });
  },

  scrollToMonth: function (month) {
    $('html,body').animate({
      scrollTop: $('#' + month).offset().top - $('#nav-custom').height()
    }, 500);
  },

  displayVenueEvents: function () {
    var venueId = window.location.search.split('=')[1];

    $.getJSON("/venues/" + venueId + ".json").success(function (venue) {
      $('.events-title').empty().append(venue.name).show();
      var events = venue.events;
      $.each(events, function (i, event) {
        console.log(event.date)
      })
    })
  },

  loadEvents: function () {
    if (window.location.search.indexOf('?venue=') > -1) {
      this.displayFiltered();
      this.displayVenueEvents()
    } else {
      this.loadAllEvents();
    }
  }
};