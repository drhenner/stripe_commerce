var Hadean = window.Hadean || { };

// If we already have the Shopping namespace don't override
if (typeof Hadean.Shopping == "undefined") {
    Hadean.Shopping = {};
}
var debug_variable = null;
// If we already have the Cart object don't override
if (typeof Hadean.Shopping.cart == "undefined") {

    Hadean.Shopping.cart = {
        initialize      : function( ) {
          Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
          $("#new_payment").submit(function(event) {
            // disable the submit button to prevent repeated clicks
            $('.cart-submit-button').attr("disabled", "disabled");

            //var amount = 1000; //amount you want to charge in cents
            Hadean.Shopping.cart.submitForm();

            // prevent the form from submitting with the default action
            return false;
          });
          /*
          $('#use-card-on-file-button').click(function(){
            paymentProfileId = $('input[name=use_credit_card_on_file]:checked', '#new_payment').val();
            if (paymentProfileId > 0){
              Hadean.Shopping.cart.submitPaymentProfileForm();
              return false;
            } else {
              alert('Please select a card.');
            }
          }) */
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
            Stripe.createToken({
                name:     $('#full_name').val(),
                number:     $('#number').val(),
                cvc:        $('#verification_value').val(),
                exp_month:  $('#month').val(),
                exp_year:   $('#year').val()
            }, Hadean.Shopping.cart.stripeResponseHandler);
          } else {
            $('.cart-submit-button').attr("disabled", false);
            $(".payment-errors").html("Credit Card is not valid.");
            $(".payment-errors").fadeIn();
          }
        },
        stripeResponseHandler : function(status, response) {
            if ((status != 200) ||  response.error) {
                //show the errors on the form
                $('.cart-submit-button').attr("disabled", false);
                $(".payment-errors").html(response.error.message);
                $(".payment-errors").fadeIn();
            } else  {
                var form = $("#new_payment");
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
        }
    };

    // Start it up
    jQuery(function() {
      Hadean.Shopping.cart.initialize();
    });
}
