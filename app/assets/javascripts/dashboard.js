var barcode = "";
var isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;
// Opera 8.0+ (UA detection to detect Blink/v8-powered Opera)
var isFirefox = typeof InstallTrigger !== 'undefined';   // Firefox 1.0+
var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
// At least Safari 3+: "[object HTMLElementConstructor]"
var isChrome = !!window.chrome && !isOpera;              // Chrome 1+
var isIE = /*@cc_on!@*/false || !!document.documentMode; // At least IE6
$(function() {
    $(window).keypress(function(e) {
        if (isFirefox || isIE){
            barcode = barcode.concat(e.key);

        }else if (isChrome || isSafari || isOpera){
            barcode = barcode.concat(String.fromCharCode(e.keyCode));

        }
        if(barcode.length ==9){
            console.log(barcode);
            $("#user_ucard_no").val(barcode);
            $('form.simple_form').submit();
        }
    });
});