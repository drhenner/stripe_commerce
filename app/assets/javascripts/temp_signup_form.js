var Hadean = window.Hadean || {};

// If we already have the Appointments namespace don't override
if (typeof Hadean.Welcome == "undefined") {
    Hadean.Welcome = {};
}
debug_var = null;
// If we already have the Appointments object don't override
if (typeof Hadean.Welcome.tempSignup == "undefined") {

    Hadean.Welcome.tempSignup = {

        initialize      : function( ) {
          // If the user clicks add new variant button
          jQuery('#new_user').submit(function(event) {
            Hadean.Welcome.tempSignup.submitForm();

            // prevent the form from submitting with the default action
            return false;
          });
          jQuery(document).on('click', ' #submit-notify', function() {
            Hadean.Welcome.tempSignup.submitForm();
          });
          if (Hadean.Welcome.tempSignup.isMobile()) {
            Hadean.Welcome.tempSignup.setMobileCss();
          }
        },
        isMobile : function(){
          return ( /Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent) );
        },
        setMobileCss : function() {
          $('.anystretch img').hide();
          $('#body_wrapper').css('background', '#888');
          $('#signup_form_wrapper').css('background-color', '#888');
          $('#signup_form_wrapper').css('top', 0);
          $('#signup_form_wrapper').css('left', 0);
          $('#signup_form_wrapper').css('width', '100%');
          $('#signup_form_wrapper').css('margin', '0px auto');
          $('#signup_form_wrapper .styled-select').css({'background-color': '#fff', 'height': '41px', 'margin-top': '3px'});
          $('#signup_form_wrapper select').css({'width': '100%', 'color': '#7f7f7f', 'font-size': '12px', 'height': '41px'});
          $('#signup_form_wrapper input').css({'background-color': '#fff', 'font-size': '12px', 'height': '41px', 'margin-bottom': '15px'});
          $('.nofity-button-wrapper').css('margin-top', '14px');
          $('.nofity-button-wrapper').css({'padding-left': '0', 'text-align': 'left'});
          $('#mobile-banner').show();
          $('#mobile-banner').css('text-align', 'center');
          $('#mobile-banner').css('background-color', '#000');
          $('#key-to-changing').css('display', 'none');
          $('#main-landing-signup-image').hide();
          $('#mobile-landing-signup-image').show();
          $('#mobile-landing-signup-image').css('width', '320px');
          $('#input-fields').css('width', 'auto');
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
          //$('#background-transparent').css('width', 353);
          //$('#background-non-transparent').css('width', 353);
          $('#rore-logo').css('float', 'none');
          $('#rore-logo').css({'background-color': '#aca3a8', 'text-align': 'center', 'width': '100%'});
          $('#please-subscribe').show().css({'color': '#7f7f7f', 'text-align': 'center'});
          $('#congrats_user').css({'text-align': 'center', 'color': '#7f7f7f', 'margin-top': '40px', 'font-size': '24px', 'font-weight': '700', 'line-height': '26px'});
          $('#submit-notify').css({'box-shadow': 'none', 'background-color': '#ee2023', 'border': 'none', 'font-weight': '700', 'padding': '8px 19px 5px', 'width': '110px'});
          $('#link-login').show().css({'margin-top': '30px', 'display': 'block'});
          $('#link-privacy').hide();
          $('#prefooter_wrapper').hide();
          $('#signup_form_wrapper ul').css('padding-top', '17px');
        },
        submitForm : function(){
          jQuery.ajax({
            type : "POST",
            url: "/users",
            data: jQuery('#new_user').serialize(),
            success: function(jsonText){
              debug_var = jsonText;
              if (typeof( debug_var.errors) == "undefined") {
                jQuery('#new_user').hide();
                jQuery('#please-subscribe').hide();
                jQuery('#background-non-transparent h2').hide();
                jQuery('#congrats_user').fadeIn();
              }else{
                jQuery('#user_email').removeClass('error');
                jQuery('#user_country_id').removeClass('error');
                $.each(jQuery.parseJSON( debug_var.errors ), function(index, value) {
                  if (value != null) {
                    jQuery('#user_' + index).addClass('error');
                    if (index == 'email') {
                      alert("Email: " + value)
                    }
                  }
                })
              }
            },
            dataType: 'json'
          });
        }
    };

    jQuery(function() {
      Hadean.Welcome.tempSignup.initialize();
    });
};
