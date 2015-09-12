window.onload = function() {
    document.getElementById("loan_barcode").focus();
};

$("#loan_barcode").focus();
var barcode = "";
$(function() {
    $(window).keypress(function(e) {
        if(e.keyCode == 13 ){
            console.log(barcode);
            $("#loan_barcode").val(barcode);
            $('#new_loan').submit();
            barcode = '';
        }else{
            barcode += String.fromCharCode(e.keyCode);
        }
    });
});