var barcode = "";

$(function() {
    $(window).keypress(function(e) {
        if (isFirefox || isIE){
            barcode = barcode.concat(e.key);
        }else if (isChrome || isSafari || isOpera){
            barcode = barcode.concat(String.fromCharCode(e.keyCode));
        }
        if(barcode.length == 9){
            console.log(barcode);
            $("#user_ucard_no").val(barcode);
            $('form.simple_form').submit();
        }
    });
});