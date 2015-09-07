window.onload = function() {
    document.getElementById("loan_item_id").focus();
};

$("#loan_item_id").focus();
var barcode = "";
$(function() {
    $(window).keypress(function(e) {
        barcode += String.fromCharCode(e.keyCode);

        if(barcode.length ==9){
            console.log(barcode);
            $("#loan_item_id").val(barcode);
            $('#new_loan').submit();
        }
    });
});