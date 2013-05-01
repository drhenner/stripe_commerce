// media-purchase
var Hadean = window.Hadean || { };

if (typeof Hadean.ProductPage == "undefined") {
    Hadean.ProductPage = {};
}
if (typeof Hadean.ProductPage.mediaPurchase == "undefined") {

    Hadean.ProductPage.mediaPurchase = {
        currentIndex : 0,
        initialize      : function( ) {
          // If the user clicks add new variant button
          // Hadean.ProductPage.mediaPurchase
          if ($.browser.msie) {
            $("select.media-purchase").change(function() {
              Hadean.ProductPage.mediaPurchase.changeIESelection(this);
            });
          } else {
            $('div.media-purchase ul').on('mouseup', 'li', function(event) {
              Hadean.ProductPage.mediaPurchase.changeSelection(this);
            });
          }

          $('.has-tip.tip-left .icon-minus-sign ').hover( function() {
            //Hadean.ProductPage.mediaPurchase.removeNub();
            setTimeout("Hadean.ProductPage.mediaPurchase.removeNub()", 10);
          });
          //setTimeout("Hadean.ProductPage.mediaPurchase.removeNub()", 250);
        },
        changeIESelection :function(thisObj) {
          form = $(thisObj).parents('form');
          form.get(0).submit();
        },
        changeSelection : function(thisObj) {
          needToFind = true;
          jQuery.each($("select.media-purchase option"), function(index, obj) {
            if ($(obj).text() == $(thisObj).text() && needToFind) {
              needToFind = false;
              $("select.media-purchase option").val($(obj).val());
              form = $(obj).parents('form');
              form.get(0).submit();
              // time to make a form submission with the new value

            }
          })
        },
        removeNub : function() {
          $.each($('.tooltip.tip-left > .nub'), function(i, obj) {
            $(obj).hide();
          });
        }

    };
    jQuery(function() {
      Hadean.ProductPage.mediaPurchase.initialize();
    });
}
