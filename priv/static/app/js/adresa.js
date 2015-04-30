function populeazaTari() {
    $.getJSON('adresa/getCountries', function(jd) {
        var tari = jd.tari;
        for (var i=0; i< tari.length; i++){
            var tara = '<option value="' + tari[i].cod+'">'+ tari[i].nume+'</option>';
            $('#tara').append(tara);
        }
        });
    };

$(document).ready(function(){
    populeazaTari();
});

