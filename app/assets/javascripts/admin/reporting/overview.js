var Hadean = window.Hadean || {};

// If we already have the Admin namespace don't override
if (typeof Hadean.Admin == "undefined") {
    Hadean.Admin = {};
}
var debugVar = null;
// If we already have the purchaseOrder object don't override
if (typeof Hadean.Admin.reportingOverview == "undefined") {

    Hadean.Admin.reportingOverview = {
        //test    : null,
        initialize      : function( ) {
          $("#request_report_form").submit(function(event) {
            // disable the submit button to prevent repeated clicks
            $('.report-submit-button').attr("disabled", "disabled");
debugVar = event;
            //var amount = 1000; //amount you want to charge in cents
            Hadean.Admin.reportingOverview.requestReport(event);

            // prevent the form from submitting with the default action
            return false;
          });
        },
        requestReport : function(obj) {
          var form = $("#request_report_form");
          $('#schedule').val('weekly');
          form.get(0).submit();

        }
    };

    jQuery(function() {
      Hadean.Admin.purchaseOrder.initialize();
    });
}
