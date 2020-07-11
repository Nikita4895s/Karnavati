//= require turbolinks
//= require jquery
//= require jquery-ui
//= require popper
//= require bootstrap
//= require rails-ujs
//= require_tree .

$(document).ready(function(){
  set_selected_ids();
});
function set_selected_ids() {
  $('.cello_master_id').change(function(){
    selected_values = [];
    $('.cello_master_id:checked').each(function(){
      selected_values.push($(this).val());
    });
    $('#selected_ids').val(selected_values);
  });
}