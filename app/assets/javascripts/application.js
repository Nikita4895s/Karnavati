//= require turbolinks
//= require jquery
//= require jquery-ui
//= require popper
//= require bootstrap
//= require rails-ujs
//= require_tree .

$(document).ready(function(){
  set_selected_ids();
  rate_calculation();
  search_data();
  download_pdf_from();
  $('#inputGroupFile01').change(function(){
    $('label.custom-file-label').text($('#inputGroupFile01').val().split('\\').pop());
  });
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
function rate_calculation() {
  $('.discount_field').change(function(){
    Id = $(this).data('id');
    $.ajax({
      url: "/update_discount",
      method: 'patch',
      data: {
        id: Id,
        discount: $(this).val()
      },
      success: function (data, status, xhr) {// success callback function
        $('#rate_'+Id).text(data['rate']);
      }
    })
  });
}
function search_data() {
  $('.company_name_select').select2();
  $('.divison_select').select2();
  $('.category_select').select2();
  $('.product_select').select2();
  $('.capacity_select').select2();
  $('.company_name_select').change(function(){
    $.ajax({
      url: "/search_data",
      method: 'GET',
      data: {
        company_name: $(this).val()
      }
    })
  });
  $('.divison_select').change(function(){
    $.ajax({
      url: "/search_data",
      method: 'GET',
      data: {
        company_name: $('.company_name_select').val(),
        divison: $(this).val()
      }
    })
  });
  $('.category_select').change(function(){
    $.ajax({
      url: "/search_data",
      method: 'GET',
      data: {
        company_name: $('.company_name_select').val(),
        divison: $('.divison_select').val(),
        category: $(this).val()
      }
    })
  });
  $('.product_select').change(function(){
    $.ajax({
      url: "/search_data",
      method: 'GET',
      data: {
        company_name: $('.company_name_select').val(),
        divison: $('.divison_select').val(),
        category: $('.category_select').val(),
        product_name: $(this).val()
      }
    })
  });
}

function download_pdf_from() {
  $('#download_pdf_submit').click(function(){
    setTimeout(function(){
      $('#download_pdf_form')[0].reset();
    }, 1000);
    $('.cello_master_id:checked').each(function(){
      $(this).prop("checked", false);
    });
  })
}