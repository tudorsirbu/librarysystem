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

$(document).on('ajax:success',"#new_loan", function(xhr, data, response) {
    return $.gritter.add({
        image: '/assets/success.png',
        title: 'Notification',
        text: 'Loan created successfully!'
    });
});

$(document).on('ajax:error',"#new_loan", function(xhr, data, response) {
    return $.gritter.add({
        image: '/assets/error.png',
        title: 'Notification',
        text: 'This item was not returned properly, please contact Heather Wilson!'
    });
});