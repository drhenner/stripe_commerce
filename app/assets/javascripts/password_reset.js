var Hadean = window.Hadean || {};

// If we already have the Appointments namespace don't override
if (typeof Hadean.Welcome == "undefined") {
    Hadean.Welcome = {};
}
debug_var = null;
// If we already have the passReset object don't override
if (typeof Hadean.Welcome.passReset == "undefined") {

    Hadean.Welcome.passReset = {

        initialize      : function( ) {
          // If the user clicks add new variant button
          jQuery('#reset-password').submit(function(event) {
            Hadean.Welcome.passReset.submitForm();

            // prevent the form from submitting with the default action
            return false;
          });
          jQuery(document).on('click', ' #submit-notify', function() {
            Hadean.Welcome.passReset.submitForm();
          });
          if (Hadean.Welcome.passReset.isMobile()) {
            Hadean.Welcome.passReset.setMobileCss();
          }
        },
        isMobile : function(){
          return ( /Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent) );
        },
        setMobileCss : function() {
          $('.anystretch img').hide();
          $('#body_wrapper').css('background', '#888');
          $('#password_reset_form_wrapper').css('background-color', '#888');
          $('#password_reset_form_wrapper').css('top', 0);
          $('#password_reset_form_wrapper').css('left', 0);
          $('#password_reset_form_wrapper').css('width', '100%');
          $('#password_reset_form_wrapper').css('margin', '0px auto');
          $('#password_reset_form_wrapper input').css({'background-color': '#fff', 'font-size': '12px', 'height': '41px', 'margin-bottom': '15px'});
          $('.nofity-button-wrapper').css({'margin-top': '14', 'padding-left': '0'});
          $('#mobile-banner').show();
          $('#mobile-banner').css({'background-color': '#000', 'text-align': 'center', 'width': '100%'});
          $('#key-to-changing').css('display', 'none');
          $('#main-landing-signup-image').hide();
          $('#mobile-landing-signup-image').show();
          $('#mobile-landing-signup-image').css({'display': 'block', 'margin': '0 auto'});
          $('#input-fields').css('width', '100%');
          $('#input-fields').css('float', 'none');
          $('#input-fields').css('padding', '0');
          $('#input-fields').css('min-height', '320px');
          $('#background-transparent').hide();
          $('#background-non-transparent').css('min-height', '320px');
          $('#background-non-transparent').css({'background-color': '#fff', 'padding': '12px 35px 10px', 'margin': '0 auto', 'position': 'relative', 'width': '100%'});
          $('#background-non-transparent h2').css({'color': '#7f7f7f', 'font-size': '20px', 'font-weight': '700', 'line-height': '24px', 'margin-top': '0', 'text-align': 'center'});
          $.each($('#input-fields li'), function(index, obj){
            $(obj).removeClass();
            $(obj).css('padding-right', '0');
            $(obj).css('width', '100%');
            $(obj).css('display', 'block');
            $(obj).css('float', 'none');
          })
          $('#rore-logo').css('float', 'none');
          $('#rore-logo').css({'background-color': '#aca3a8', 'text-align': 'center', 'width': '100%'});
          $('#please-subscribe').show().css({'color': '#7f7f7f', 'text-align': 'center'});
          $('#congrats_user').css({'text-align': 'center', 'color': '#7f7f7f', 'margin-top': '40px', 'font-size': '20px', 'font-weight': '700', 'line-height': '26px'});
          $('#submit-notify').css({'box-shadow': 'none', 'background-color': '#ff0000', 'border': 'none', 'font-size': '14px', 'font-weight': '700', 'width': 'auto'});
          $('#prefooter_wrapper').hide();
          $('#signup_form_wrapper ul').css('padding-top', '17px');
        },
        submitForm : function(){
          jQuery.ajax({
            type : "POST",
            url: "/customer/password_reset",
            data: jQuery('#reset-password').serialize(),
            success: function(jsonText){
              debug_var = jsonText;
              if (typeof( jsonText.errors) == "undefined") {
                jQuery('#reset-password').hide();
                jQuery('#please-subscribe').hide();
                jQuery('#background-non-transparent h2').hide();
                jQuery('#congrats_user').fadeIn();
              }else{
                jQuery('#user_email').removeClass('error');
                jQuery('#user_country_id').removeClass('error');
                alert(jsonText.errors);
              }
            },
            dataType: 'json'
          });
        }
    };

    jQuery(function() {
      Hadean.Welcome.passReset.initialize();
    });
};
