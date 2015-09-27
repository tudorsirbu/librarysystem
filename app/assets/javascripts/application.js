// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require gritter
//= require turbolinks
//= require select2

function timedRefresh() {
    setTimeout("location.reload(true);",30001);
}

$.extend($.gritter.options, {
    fade_in_speed: 'slow', // how fast notifications fade in (string or int)
    fade_out_speed: 1200, // how fast the notices fade out
    time: 1200 // hang on the screen for...
});
