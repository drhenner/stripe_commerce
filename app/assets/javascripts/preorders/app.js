(function ($, window, undefined) {
  'use strict';

  var $doc = $(document),
      Modernizr = window.Modernizr;


  $.fn.foundationAlerts           ? $doc.foundationAlerts() : null;
  $.fn.foundationAccordion        ? $doc.foundationAccordion() : null;
  $.fn.foundationTooltips         ? $doc.foundationTooltips() : null;
  $('input, textarea').placeholder();


  $.fn.foundationButtons          ? $doc.foundationButtons() : null;


  $.fn.foundationNavigation       ? $doc.foundationNavigation() : null;


  $.fn.foundationTopBar           ? $doc.foundationTopBar() : null;

  $.fn.foundationCustomForms      ? $doc.foundationCustomForms() : null;
  $.fn.foundationMediaQueryViewer ? $doc.foundationMediaQueryViewer() : null;


    $.fn.foundationTabs             ? $doc.foundationTabs() : null;



    $("#featured").orbit();


  // UNCOMMENT THE LINE YOU WANT BELOW IF YOU WANT IE8 SUPPORT AND ARE USING .block-grids
  // $('.block-grid.two-up>li:nth-child(2n+1)').css({clear: 'both'});
  // $('.block-grid.three-up>li:nth-child(3n+1)').css({clear: 'both'});
  // $('.block-grid.four-up>li:nth-child(4n+1)').css({clear: 'both'});
  // $('.block-grid.five-up>li:nth-child(5n+1)').css({clear: 'both'});

  // Hide address bar on mobile devices
  if (Modernizr.touch) {
    $(window).load(function () {
      setTimeout(function () {
        window.scrollTo(0, 1);
      }, 0);
    });
  }

})(jQuery, this);


// Slider Revolution

jQuery('.fullwidthbanner').revolution(
{
              delay:9000,
              startwidth:890,
              startheight:450,

              onHoverStop:"on",           // Stop Banner Timet at Hover on Slide on/off

              thumbWidth:100,             // Thumb With and Height and Amount (only if navigation Tyope set to thumb !)
              thumbHeight:50,
              thumbAmount:3,

              hideThumbs:200,
              navigationType:"bullet",          //bullet, thumb, none, both  (No Shadow in Fullwidth Version !)
              navigationArrows:"verticalcentered",    //nexttobullets, verticalcentered, none
              navigationStyle:"round",        //round,square,navbar

              touchenabled:"on",            // Enable Swipe Function : on/off

              navOffsetHorizontal:0,
              navOffsetVertical:20,

              stopAtSlide:-1,             // Stop Timer if Slide "x" has been Reached. If stopAfterLoops set to 0, then it stops already in the first Loop at slide X which defined. -1 means do not stop at any slide. stopAfterLoops has no sinn in this case.
              stopAfterLoops:-1,            // Stop Timer if All slides has been played "x" times. IT will stop at THe slide which is defined via stopAtSlide:x, if set to -1 slide never stop automatic



              fullWidth:"on",

              shadow:0                //0 = no Shadow, 1,2,3 = 3 Different Art of Shadows -  (No Shadow in Fullwidth Version !)
});


$(function() {
            $(".contentHover").hover(
                function() {
                    $(this).children(".content").fadeTo(200, 0.25).end().children(".hover-content").fadeTo(200, 1).show();
                },
                function() {
                    $(this).children(".content").fadeTo(200, 1).end().children(".hover-content").fadeTo(200, 0).hide();
                });
        });

// Flexi Slider



  // Target sliders individually with different properties
  $(window).load(function() {

    $('.simple-slider').flexslider({
        animation: "slide",
    slideshow: false,
    controlNav: false,
    smoothHeight: true,
        start: function(slider){
          $('body').removeClass('loading');
        }
      });

  $('.gallery-slider').flexslider({
        animation: "slide",
    controlNav: "thumbnails",
        start: function(slider){
          $('body').removeClass('loading');
        }
  });

    $('#main-slider').flexslider({
        animation: "slide",
    controlNav: false,
        start: function(slider){
          $('body').removeClass('loading');
        }
  });
  });



