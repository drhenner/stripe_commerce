var Hadean = window.Hadean || {};

// If we already have the Appointments namespace don't override
if (typeof Hadean.Welcome == "undefined") {
    Hadean.Welcome = {};
}

// If we already have the Appointments object don't override
if (typeof Hadean.Welcome.rotateImages == "undefined") {

    Hadean.Welcome.rotateImages = {
        transitionSpeed    : 475,
        speed    : 5000,
        images   : [],
        currentIndex : 0,
        initialize      : function( ) {
          // If the user clicks add new variant button
          Hadean.Welcome.rotateImages.images = ['/assets/landing_page/background-1.jpg','/assets/landing_page/background-2.jpg','/assets/landing_page/background-3.jpg','/assets/landing_page/background-4.jpg']
          Hadean.Welcome.rotateImages.next();
        },
        setNext : function(){
          setTimeout('Hadean.Welcome.rotateImages.next()', Hadean.Welcome.rotateImages.speed);
        },
        isMobile : function(){
          return ( /Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent) );
        },
        next : function(){
          if (Hadean.Welcome.rotateImages.isMobile()) {
            //
          } else {
            $('.anystretch').show();
            $.anystretch(Hadean.Welcome.rotateImages.images[Hadean.Welcome.rotateImages.currentIndex], {speed: Hadean.Welcome.rotateImages.transitionSpeed});
          }

          Hadean.Welcome.rotateImages.currentIndex = Hadean.Welcome.rotateImages.nextIndex();
          Hadean.Welcome.rotateImages.setNext();
        },
        prev : function(obj){
          $.anystretch(Hadean.Welcome.rotateImages.images[Hadean.Welcome.rotateImages.currentIndex], {speed: Hadean.Welcome.rotateImages.transitionSpeed});
          Hadean.Welcome.rotateImages.currentIndex = Hadean.Welcome.rotateImages.prevIndex();
        },
        nextIndex : function() {
          if ((Hadean.Welcome.rotateImages.currentIndex + 1) >= Hadean.Welcome.rotateImages.numberOfImages()) {
            return 0;
          } else {
            return (Hadean.Welcome.rotateImages.currentIndex + 1);
          }
        },
        prevIndex : function() {
          if ((Hadean.Welcome.rotateImages.currentIndex - 1) <= 0) {
            return 0;
          } else {
            return (Hadean.Welcome.rotateImages.currentIndex - 1);
          }
        },
        numberOfImages : function(){
          return Hadean.Welcome.rotateImages.images.length;
        }
    };

    jQuery(function() {
      Hadean.Welcome.rotateImages.initialize();
    });
};
