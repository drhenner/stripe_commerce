var Hadean = window.Hadean || { };

Hadean.Validators = {
  CreditCards : {
    currentCardType : null,
    creditCardInput : null,
    valid : false,
    cardRegexps     : [
                           [ 'Visa Electron'      , /^(417500|(4917|4913|4508|4844)\d{2})\d{10}$/ ]
                         , [ 'Visa'               , /^4\d{12}(\d{3})?$/                           ]
                         , [ 'MasterCard'         , /^(5[1-5]\d{4}|677189)\d{10}$/                ]
                         , [ 'discover'           , /^(6011|65\d{2})\d{12}$/                      ]
                         , [ 'American Express'   , /^(34|37)\d{13}$/                             ]
                        , [ 'Diners Club'        , /^3(0[0-5]|[68]\d)\d{11}$/                    ]
                      //  , [ 'JCB'                , /^35(2[89]|[3-8]\d)\d{12}$/                ]
                      //   , [ 'Solo'               , /^(6767|6334)\d{12}(\d{2,3})?$/               ]
                      // , [ 'dankort'            , /^5019\d{12}$/                                ]
                      //   , [ 'Maestro'            , /^((5018|5020|5038|6304|6759|6761|4903|4905|4911|4936|6333|6759)\d{2}|564182|633100)\d{10,13}$/ ]
                      // , [ 'forbrugsforeningen' , /^600722\d{10}$/                              ]
                      //   , [ 'Laser'              , /^(6304|6706|6771|6709)\d{12,15}$/            ]
                      ],
    initialize      : function() {
      Hadean.Validators.CreditCards.creditCardInput = $('#number');
      var cardInput = jQuery(Hadean.Validators.CreditCards.creditCardInput);
      cardInput.
              bind('blur', function() {
                  Hadean.Validators.CreditCards.validateNumber(Hadean.Validators.CreditCards.creditCardInput);
                }
              );
    },
    hasInvalidDate : function () {
      if (Number($('#year').val()) == $('#valid-cc').data('year') && Number($('#month').val()) < $('#valid-cc').data('month')) {
        return true;
      } else {
        return false;
      }
    },
    validateNumber : function(creditCardInputObject) {
      number = creditCardInputObject.val();
      //does it pass the luhn calculation
      validLuhnValue = Hadean.Validators.CreditCards.validLuhn(number);
      //does it pass the CC regEX
      validRegExValue = Hadean.Validators.CreditCards.validRegEx(number);
      if (validLuhnValue && validRegExValue) {
        //GOOD now remove any error messages
        Hadean.Validators.CreditCards.valid = true;
        creditCardInputObject.parent("div").removeClass('errors')
      } else {
        // Give the user an error message
        Hadean.Validators.CreditCards.valid = false;
        creditCardInputObject.parent("div").addClass('errors')
      }
    },
    validLuhn : function(number) {
      if (number.length > 19)
          return (false);

      sum = 0; mul = 1; l = number.length;
      for (i = 0; i < l; i++)
      {
          digit = number.substring(l-i-1,l-i);
          tproduct = parseInt(digit ,10)*mul;
          if (tproduct >= 10){
            sum += (tproduct % 10) + 1;
          } else {
            sum += tproduct;
          }

          if (mul == 1){
            mul++;
          } else {
            mul--;
          }
      }
      if ((sum % 10) == 0) {
       return (true);
      } else {
       return (false);
      }
    },
    validRegEx : function(number) {
        thisCardType = Hadean.Validators.CreditCards.cardType(number);
        if (thisCardType == null) {
          return (false);
        }else{
          return (true);
        }
        return thisCardType;
    },
    cardType : function(number) {
      var name = null;
      jQuery.each(Hadean.Validators.CreditCards.cardRegexps, function (i,e) {
        if (number.match(e[1])) {
          name = e[0];
          return false;
        }
      });
      return name;
    }
  }
}
Hadean.Validators.CreditCards.initialize();

