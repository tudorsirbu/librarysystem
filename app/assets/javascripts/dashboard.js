var barcode = "";
$(function() {
    $(window).keypress(function(e) {
        barcode = barcode.concat(String.fromCharCode(e.keyCode));

        if(barcode.length ==9){
            console.log(barcode);
            $("#user_ucard_no").val(barcode);
            $('form.simple_form').submit();
        }
    });
});