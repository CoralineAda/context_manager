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
//= require bootstrap-sprockets
//= require_tree .
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

$(function() {

  $('.datatable').DataTable({
    paging: false,
    columnDefs: [
      {"orderable": false, "targets": 'no_sort'},
      {"searchable": false, "targets": 'no_search'}
    ]
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    // processing: true,
    // serverSide: true,

    // Optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about available options.
    // http://datatables.net/reference/option/pagingType
  });

  $('form:not(.filter) :input:visible:enabled:first').focus()

  function selectVisibility() {
    var selector = $($(this).attr('data-selects-visibility'));
    if ($(this).is('input[type="checkbox"]')) {
      if ($(this).is(':checked')) {
        value = '_checked';
      } else {
        value = '_unchecked';
      }
    } else if ($(this).is('input[type=radio]')) {
      var checkedRadioButton = $(this).closest('form').find('input[type="radio"][name="' + $(this).attr('name') + '"]:checked');
      if (checkedRadioButton.length > 0) {
        value = checkedRadioButton.val();
      }
    } else {
      var value = $(this).val();
    }
    if (!value) {
      value = '_blank';
    }
    selector.filter('[data-show-for]:not([data-show-for~="' + value + '"])').hide();
    selector.filter('[data-hide-for~="' + value + '"]').hide();
    selector.filter('[data-hide-for]:not([data-hide-for~="' + value + '"])').show();
    selector.filter('[data-show-for~="' + value + '"]').show();
  }

  $(this).find('[data-selects-visibility]').change(selectVisibility);
  $(this).find('select[data-selects-visibility]').each(selectVisibility);
  $(this).find('input[data-selects-visibility][type="checkbox"]').each(selectVisibility);
  $(this).find('input[data-selects-visibility][type="radio"]:checked').each(selectVisibility);
});