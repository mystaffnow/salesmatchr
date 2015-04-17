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
//= require turbolinks
//= requier bootstrap-sprockets
//= require rails.validations
//= require_tree .

function ready(){
  ZiggeoApi.token = "f2b7325a17fc847dbabf556c596170d8";
  $('.account-panel').on('click', '.remove_fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    return event.preventDefault();
  });
  $('.account-panel').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });

  $('.selectpickers').selectpicker();

  // http://www.bootstrap-switch.org/
  $("[name='my-checkbox']").bootstrapSwitch();
  salary_slider = $("#salaries").slider({ min: 0, max: 500000, range: true, step: 5000, formatter: format_slider });
}
var salary_slider;
$(document).ready(ready);
$(document).on('page:load', ready);

function format_slider(val){
  return "$" + val[0] + " - $" + val[1];
}