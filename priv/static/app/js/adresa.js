function populeazaTari() {
    $.getJSON('adresa/getCountries', function(jd) {
        var tari = jd.tari;
        for (var i=0; i< tari.length; i++){
            var tara = '<option value="' + tari[i].cod+'">'+ tari[i].nume+'</option>';
            $('#tara').append(tara);
        }
        });
    };

function selecteazaDefault() {
    $('#tara').val('ROMANIA').prop('selected',true);
};

$(document).ready(function(){
        $('#adaugaPacientModal').on('shown.bs.modal', function(e) {
            $("#adresa").on('click',"#tara", populeazaTari());

    });
});

