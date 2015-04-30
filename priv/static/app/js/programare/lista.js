function listen_for_events(timestamp) { // timestamp e undefined dintrun motiv
        $.ajax("/programares/pull/"+timestamp, { success: //adaugare in lista doar daca programarea e din ziua respectiva
            function(data, code, xhr) {
                for (var i=0; i< data.programari.length; i++) {
                    var programare = data.programari[0];
                    $.getJSON('/pacient/cauta/'+programare.pacient_id, function(jd) {
                    $("#programari-list").append(
                        '<tr><td> '+ programare.ora + ' </td> <td> '+ jd.pacient.nume+'</td> <td>'+ jd.pacient.prenume +'</td> <td><a href="/consults/adauga/"'+jd.pacient.id+'/'+ programare.id+' class="btn btn-primary"> Adauga consult</a></td> </tr>');
                    });
                }
            listen_for_events(data.timestamp);
        } });
    };
       
function iaAzi() {
    var Azi = moment();
    iaProgramarileDinZiua(Azi.format('DD/MM/YYYY'));
    return Azi.format('DD/MM/YYYY');
};
function convertesteOra(Ora) { 
    var oraFinala = '';
    console.log(Ora);
    Ora.forEach(function (cod) {
        oraFinala += String.fromCharCode(cod);
    });
    return oraFinala.substring(18,24); //munca degeaba substring trebuie inainte de prelucrare
};

function iaProgramarileDinZiua(zi){
    $.getJSON("/programares/listaZI/"+zi, function(jd){
        var programari = jd.programari;
        var pacienti = jd.pacienti;
        var ore = jd.ore;
        $('#programari-list tbody').empty();
        if (programari.length !=0){
            for (var i=0; i<programari.length; i++) {
                var oraConsult = programari[i].ora;//convertesteOra(programari[i].ora);
                $('#programari-list tbody').append('<tr><td> '+ oraConsult +'</td><td> '+ programari[i].durata + '</td><td>'+ pacienti[i].nume+'</td><td>'+ pacienti[i].prenume +'</td><td><a href="/consults/adauga/'+pacienti[i].id+'/'+programari[i].id +'"/ class="btn btn-primary"> Adauga consult</a></td><td>ce plm</td></tr>');
            }}
            else {
                $('#programari-list tbody').append('<tr><td>Azi</td><td>nu</td><td>ai</td><td>programări</td><tr>');
            }
    });
}



$(document).ready(function () {
    $('#programariPicker').val(moment().format('DD/MM/YYYY'));
    $('#programariPicker').datetimepicker({
        pickTime: false,
        language: "ro",
        useCurrent: true,
        }).on('dp.change', function (ev) {
            $('#programari-list tbody').empty();
            var dataZi = $('#programariPicker').val();
            iaProgramarileDinZiua(dataZi);
            $(this).datetimepicker('hide');
        });
    $('#ieri').on('click', function(e){
        var Zi = moment($('#programariPicker').val(), "DD/MM/YYYY");
        Zi.subtract(1, 'days');
        $('#programariPicker').val((Zi.format('DD/MM/YYYY')));
        iaProgramarileDinZiua(Zi.format('DD/MM/YYYY'));
        });

    $('#maine').on('click', function(e){ 
        var Zi = moment($('#programariPicker').val(), "DD/MM/YYYY");
        Zi.add(1, 'days');
        $('#programariPicker').val((Zi.format('DD/MM/YYYY')));
        iaProgramarileDinZiua(Zi.format('DD/MM/YYYY'));
    });
    listen_for_events($("#timestamp").val());
        });
