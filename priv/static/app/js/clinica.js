function populeazaJudete() {
    $.getJSON('/adresa/populeaza_judete/', function(jd) {
        var judete = jd.judete;
        $('#judete option').remove();
        for (var i=0; i< judete.length; i++) {
            $("#judete").append('<option value="'+judete[i].cod+'">' + judete[i].nume + '</option>');
        }
    });
};

function populeazaOrase(Judet) {
    $.getJSON('/adresa/populeaza_orase/'+Judet+'/', function(jd){
        $("#oras").prop("disabled", false);
        var orase = jd.orase;
        $("oras option").remove();
        for (var i=0; i<orase.length; i++) {
            $("#oras").append('<option value="'+orase[i].cod+'">'+ orase[i].nume+'</option>');
        }
    });
};


$(document).ready(function(){
    $('#poza').fileinput();
    populeazaJudete();
    $('#judete').change( function ()
            {
                populeazaOrase($('#judete').val());
            });

    });
