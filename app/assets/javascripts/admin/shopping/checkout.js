var Hadean = window.Hadean || { };

// If we already have the AdminShopping namespace don't override
if (typeof Hadean.AdminShopping == "undefined") {
    Hadean.AdminShopping = {};
}
var debug_variable = null;
// If we already have the Cart object don't override
if (typeof Hadean.AdminShopping.cart == "undefined") {

    Hadean.AdminShopping.cart = {
        initialize      : function( ) {
          Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
          $("#purchase_admin_order").submit(function(event) {
            // disable the submit button to prevent repeated clicks
            $('.cart-submit-button').attr("disabled", "disabled");

            //var amount = 1000; //amount you want to charge in cents
            Hadean.AdminShopping.cart.submitForm();

            // prevent the form from submitting with the default action
            return false;
          });
          $('#use-card-on-file-button').click(function(){
            paymentProfileId = $('input[name=use_credit_card_on_file]:checked', '#purchase_admin_order').val();
            if (paymentProfileId > 0){
              Hadean.AdminShopping.cart.submitPaymentProfileForm();
              return false;
            } else {
              alert('Please select a card.');
            }
          })
        },
        submitPaymentProfileForm : function () {
          jQuery.ajax({
            type : "GET",
            url: "/shopping/orders/xyz",
            success: function(jsonText){
              // if the price they see is what we will be charging... Proceed
              if ( jsonText.order.integer_credited_total == Hadean.AdminShopping.cart.orderAmount()) {
                var form = $("#purchase_admin_order");
                form.get(0).submit();
              } else {
                $(".payment-errors").html("Error handling transaction.");
                window.location.href = "/admin/shopping/checkout/orders";
              }
            },
            dataType: 'json'
          });
        },
        submitForm : function () {
          // don't submit if this isn't valid
          Hadean.Validators.CreditCards.validateNumber(Hadean.Validators.CreditCards.creditCardInput);
          if (Hadean.Validators.CreditCards.hasInvalidDate()) {
            $(".payment-errors").html("The Credit card must not expire before " +  $('#valid-cc').data('mindate'));
            $(".payment-errors").fadeIn();
            $('.cart-submit-button').attr("disabled", false);
          } else if (Hadean.Validators.CreditCards.valid) {
            $(".payment-errors").fadeOut();
            // get the amount
            jQuery.ajax({
              type : "GET",
              url: "/admin/shopping/checkout/order/total",
              success: function(jsonText){
                // if the price they see is what we will be charging... Proceed
                if ( jsonText.order.integer_credited_total == Hadean.AdminShopping.cart.orderAmount()) {
                  Stripe.createToken({
                      name:     $('#full_name').val(),
                      number:     $('#number').val(),
                      cvc:        $('#verification_value').val(),
                      exp_month:  $('#month').val(),
                      exp_year:   $('#year').val()
                  }, Hadean.AdminShopping.cart.stripeResponseHandler);
                } else {
                  alert('payment-errors');
                  $(".payment-errors").html("Error handling transaction.");
                  window.location.href = "/admin/shopping/checkout/order";
                }
              },
              dataType: 'json'
            });
          } else if(Hadean.AdminShopping.cart.useCardOnFile()) {
            //
            Hadean.AdminShopping.cart.chargeCardOnFile();
          } else {
            $('.cart-submit-button').attr("disabled", false);
            $(".payment-errors").html("Credit Card is not valid.");
            $(".payment-errors").fadeIn();

          }
        },
        useCardOnFile : function(){
          //
          var cardOnFile = jQuery('#card_on_file');
          if (cardOnFile) {
            return cardOnFile.find('input:checkbox').attr('checked');
          } else {return false}
        },
        chargeCardOnFile : function(){
          Hadean.App.helpers.startWaitScreen();
          jQuery.ajax({
            type : "PUT",
            url: "/admin/shopping/checkout/orders/xyz/charge",
            data : { authenticity_token : $('meta[name="csrf-token"]').attr('content')},
            success: function(jsonText){
              // if successfully charge redirect...  otherwise display errors
              if (jsonText.order.errors) {
                //display errors
                $('.cart-submit-button').attr("disabled", false);
                $(".payment-errors").html("There was an error processing this order.");
                $(".payment-errors").fadeIn();
                Hadean.App.helpers.stopWaitScreen();
              } else {
                // redirect to order summary stylist_admin_customer_user_path(@order.user)
                window.location.href = "/admin/history/orders/"+jsonText.order.number;
              }
            },
            dataType: 'json'
          });
        },
        stripeResponseHandler : function(status, response) {
            if ((status != 200) ||  response.error) {
                //show the errors on the form
                $('.cart-submit-button').attr("disabled", false);
                $(".payment-errors").html(response.error.message);
                $(".payment-errors").fadeIn();
            } else  {
                var form = $("#purchase_admin_order");
                // token contains id, last4, and card type
                var token = response['id'];
                // insert the token into the form so it gets submitted to the server
                $('#stripe_card_token').val(token);
                $('#token_amount').val(response['amount']);

                // and submit
                form.get(0).submit();
                //$('.cart-submit-button').attr("disabled", false);
            }
        },
        lastFour : function(){
          var str = $('#number').val();
          return str.replace(/\D/g,'').substring(str.length - 4, str.length );
        },
        orderAmount : function() {
          return $('#credited_total').data('integer_credited_total');
        }
    };

    // Start it up
    jQuery(function() {
      Hadean.AdminShopping.cart.initialize();
    });
}
