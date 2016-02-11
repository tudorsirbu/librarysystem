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
            if (isFirefox || isIE){
                barcode = barcode.concat(e.key);
            }else if (isChrome || isSafari || isOpera){
                barcode = barcode.concat(String.fromCharCode(e.keyCode));
            }
        }
    });
});



$(document).on('ajax:success',"#new_loan", function(xhr, data, response) {
    console.log(data);
    if (!data.error){
        $( "select" ).change(function() {
            var id = $(this).data("id");
            var due_date = $(this).val();
            $.ajax({
                dataType: "script",
                data: { id: id, due_date : due_date},
                method: "POST",
                url: "/loans/"+ id +"/change_loan_period"
            });
        });
        return $.gritter.add({
            image: '/assets/success.png',
            title: 'Notification',
            text: 'Loan created successfully!',
            class_name: 'gritter-info gritter-center'
        });
    }else{
        return $.gritter.add({
            image: '/assets/error.png',
            title: 'Notification',
            text: data.error,
            class_name: 'gritter-info gritter-center'
        });

    }

});
