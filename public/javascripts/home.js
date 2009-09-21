// The Console handles all of the Admin interaction with the active hostss
// and job queue.
//
// Think about pulling in the DCJS framework, instead of just raw jQuery here.
// Leaving it hacked together like this just cries out for templates, dunnit?
//window.loadFirebugConsole();
window.Console = {

  // Maximum number of data points to record and graph.
  MAX_DATA_POINTS : 100,

  // Milliseconds between polling the central server for updates to Job progress.
  POLL_INTERVAL : 3000,

  // Default speed for all animations.
  ANIMATION_SPEED : 300,

  // Keep this in sync with the map in cloud-crowd.rb
  DISPLAY_STATUS_MAP : ['unknown', 'processing', 'succeeded', 'failed', 'splitting', 'merging'],

  // Images to preload
  PRELOAD_IMAGES : ['/images/icons/server--exclamation.png'],

  // All options for drawing the system graphs.
  GRAPH_OPTIONS : {
    xaxis :   {mode : null, min: 1, max: 30 }, //, timeformat : '%M:%S'},
    yaxis :   {tickDecimals : 0, min: 1, max: 100},
    legend :  {show : true},
    grid :    {backgroundColor : '#7f7f7f', color : '#555', tickColor : '#666', borderWidth : 2}
  },
  JOBS_COLOR        : '#db3a0f',
  CPU_COLOR     : '#aa2222',
  MEM_COLOR     : '#22aa22',
  NET_COLOR     : '#bbbb33',
  WORK_UNITS_COLOR  : '#ffba14',

  // Starting the console begins polling the server.
  initialize : function() {
    this._jobsHistory = [];
    this._hostsHistory = [];
    this._workUnitsHistory = [];
    this._histories = [this._jobsHistory, this._hostsHistory, this._workUnitsHistory];
    this._queue = $('#jobs');
    this._hostInfo = $('#host_info');
    this._disconnected = $('#disconnected');
   // $(window).bind('resize', Console.renderGraphs);
    $('#hosts .host').live('click', Console.getHostInfo);
    this.getStatus();
    $.each(this.PRELOAD_IMAGES, function(){ var i = new Image(); i.src = this; });
  },

  // Request the lastest status of all jobs and hosts, re-render or update
  // the DOM to reflect.
  getStatus : function() {
    $.ajax({url : '/status', dataType : 'json', success : function(resp) {
      Console._jobs           = resp.jobs;
      Console._hosts        = resp.hosts;
      Console._workUnitCount  = resp.work_unit_count;
      Console.recordDataPoint();
      if (Console._disconnected.is(':visible')) Console._disconnected.fadeOut(Console.ANIMATION_SPEED);
      $('#queue').toggleClass('no_jobs', Console._jobs.length <= 0);
      Console.renderJobs();
      Console.renderHosts();
   //   Console.renderGraphs();
      setTimeout(Console.getStatus, Console.POLL_INTERVAL);
    }, error : function(request, status, errorThrown) {
      if (!Console._disconnected.is(':visible')) Console._disconnected.fadeIn(Console.ANIMATION_SPEED);
      setTimeout(Console.getStatus, Console.POLL_INTERVAL);
    }});
  },

  // Render an individual job afresh.
  renderJob : function(job) {
    this._queue.append('<div class="job" id="job_' + job.id + '" style="width:' + job.width + '%; background: #' + job.color + ';"><div class="completion ' + (job.percent_complete <= 0 ? 'zero' : '') + '" style="width:' + job.percent_complete + '%;"></div><div class="percent_complete">' + job.percent_complete + '%</div><div class="job_id">#' + job.id + '</div></div>');
  },

  // Animate the update to an existing job in the queue.
  updateJob : function(job, jobEl) {
    jobEl.animate({width : job.width + '%'}, this.ANIMATION_SPEED);
    var completion = $('.completion', jobEl);
    if (job.percent_complete > 0) completion.removeClass('zero');
    completion.animate({width : job.percent_complete + '%'}, this.ANIMATION_SPEED);
    $('.percent_complete', jobEl).html(job.percent_complete + '%');
  },

  // Render all jobs, calculating relative widths and completions.
  renderJobs : function() {
    var totalUnits = 0;
    var totalWidth = this._queue.width();
    var jobIds = [];
    $.each(this._jobs, function() {
      jobIds.push(this.id);
      totalUnits += this.work_units;
    });
    $.each($('.job'), function() {
      var el = this;
      if (jobIds.indexOf(parseInt(el.id.replace(/\D/g, ''), 10)) < 0) {
        $(el).animate({width : '0%'}, Console.ANIMATION_SPEED - 50, 'linear', function() {
          $(el).remove();
        });
      }
    });
    $.each(this._jobs, function() {
      this.width  = (this.work_units / totalUnits) * 100;
      var jobEl = $('#job_' + this.id);
      jobEl[0] ? Console.updateJob(this, jobEl) : Console.renderJob(this);
    });
  },

    // Convert our recorded data points into a format Flot can understand.
 // renderGraphs : function(host) {
//    $.plot($('#jobs_graph'), [{label : 'Jobs in Queue', color : Console.JOBS_COLOR, data : Console._jobsHistory}], Console.GRAPH_OPTIONS);
 //   $.plot($('#work_units_graph'), [{label : 'Work Units in Queue', color : Console.WORK_UNITS_COLOR, data : Console._workUnitsHistory}], Console.GRAPH_OPTIONS);
 // },

  // Re-render all hosts from scratch each time.
  renderHosts : function() {
    var header = $('#sidebar_header');
    $('.has_hosts', header).html(this._hosts.length + " Active Hosts");
    header.toggleClass('no_hosts', this._hosts.length <= 0);
    $('#hosts').html($.map(this._hosts, function(w) {
      return '<div class="host ' + w.state + '" rel="' + w.id + '">' + w.name + '</div>';
    }).join(''));
    $('#graphs').html($.map(this._hosts, function(w) {
      return '<div class="graph_container"><div class="graph_title">' + w.name + '</div><div class="graph"  id="host_' + w.id + '"></div></div>';
    }).join(''));
    $.map(this._hosts, function(w) {
                $.plot($('#host_' + w.id), [
                       {label : 'Proc',
                        color : Console.CPU_COLOR,
                        data : w.cpu
                       },
                       {label : 'Mem',
                        color : Console.MEM_COLOR,
                        data : w.mem
                       },
                       {label : 'Net',
                        color : Console.NET_COLOR,
                        data : w.net
                       }


                       ],

                       Console.GRAPH_OPTIONS);

          });
  },

  // Record the current state and re-render all graphs.
  recordDataPoint : function() {
    var timestamp = (new Date()).getTime();
    this._jobsHistory.push([timestamp, this._jobs.length]);
    this._hostsHistory.push([timestamp, this._hosts.length]);
    this._workUnitsHistory.push([timestamp, this._workUnitCount]);
    $.each(this._histories, function() {
      if (this.length > Console.MAX_DATA_POINTS) this.shift();
    });
  },



  // Request the Host info from the central server.
  getHostInfo : function(e) {
    e.stopImmediatePropagation();
    var info = Console._hostInfo;
    var row = $(this);
    info.addClass('loading');
    $.get('/hosts/' + row.attr('rel'), null, Console.renderHostInfo, 'json');
    info.css({top : row.offset().top, left : 325});
    info.fadeIn(Console.ANIMATION_SPEED);
    $(document).bind('click', Console.hideHostInfo);
    return false;
  },

  // When we receieve host info, update the bubble.
  renderHostInfo : function(resp) {
    var info = Console._hostInfo;
    info.toggleClass('awake', !!resp.status);
    info.removeClass('loading');
    if (!resp.status) return;
    $('.status', info).html(Console.DISPLAY_STATUS_MAP[resp.status]);
    $('.action', info).html(resp.action);
    $('.job_id', info).html(resp.job_id);
    $('.work_unit_id', info).html(resp.id);
  },

  // Hide host info and unbind the global hide handler.
  hideHostInfo : function() {
    $(document).unbind('click', Console.hideHostInfo);
    Console._hostInfo.fadeOut(Console.ANIMATION_SPEED);
  }

};

$(document).ready(function() { Console.initialize(); });