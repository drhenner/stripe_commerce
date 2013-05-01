jQuery(document).ready(function($) {
  $("#create-shipment-button").click(function() {
    var url = $(this).data("url");
    jQuery.ajax( {
      type : "PUT",
      url : url,
      dataType: 'script'
    });
    return false;
  });
});

