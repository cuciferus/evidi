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
        return ore;
        }); 
        };

function faTabelulDeProgramariSaptamanal(zi) {
    $('#programari-list tbody').empty();
    var ora_deschidere = moment();
    ora_deschidere.hour(9); ora_deschidere.minute(0);//aici va fi ora deschiderii programului
    var ora_inchidere = moment();
    ora_inchidere.hour(14); ora_inchidere.minute(0);//ora inchiderii programului
    var ora_momentului = ora_deschidere;
    while (moment.min(ora_momentului, ora_inchidere) == ora_momentului) {
        $('#programari-list tbody'). append('<tr><td>'+ ora_momentului.hour()+':'+ ora_momentului.minute()+
                '<td> programare luni</td> <td></td><td> programare miercuri</td><td></td></td>programare vineri</td><td></td><td></td><td></td></tr>');
        ora_momentului.add(15,'m'); //aici durata unui consult
    };
    $('#programari-list tbody').append('</tbody></table>');
    iaProgramarileDinZiua(zi);

};

    

function faTabeluDeProgramari(zi){
    iaProgramarileDinZiua(zi);
    $('#programari-list tbody').empty();
    var ora_deschidere = moment();
    ora_deschidere.hour(9); ora_deschidere.minute(0);//aici va fi ora deschiderii programului
    var ora_inchidere = moment();
    ora_inchidere.hour(14); ora_inchidere.minute(0);//ora inchiderii programului
    var ora_momentului = ora_deschidere;
    while (moment.min(ora_momentului, ora_inchidere) == ora_momentului) { //inainte de buton verifica daca ai programari la ora respectiva
        $('#programari-list tbody').append('<tr><td> '+ ora_momentului.hour()+':'+ ora_momentului.minute()+
                '</td><td> <button type="button" class="btn btn-info" data-toggle="modal" data-target="#adaugaProgramareOra" data-ora="'
                +ora_momentului.hour()+'" data-minut="'+ ora_momentului.minute() +'"> Adaugă programare</button></td><td>scopul/durata/cnp</td></tr>');
        ora_momentului.add(15,'m');
    }
};

$(document).ready(function () {
    var azi = moment().format('DD/MM/YYYY');
    $('#programariPicker').val(azi);
    faTabeluDeProgramari(azi);
    $('#programariPicker').datetimepicker({
        pickTime: false,
        language: "ro",
        useCurrent: true,
        }).on('dp.change', function (ev) {
            $('#programari-list tbody').empty();
            var dataZi = $('#programariPicker').val();
            faTabeluDeProgramari(dataZi);
            $(this).datetimepicker('hide');
        });
    $('#ieri').on('click', function(e){
        var Zi = moment($('#programariPicker').val(), "DD/MM/YYYY");
        Zi.subtract(1, 'days');
        $('#programariPicker').val((Zi.format('DD/MM/YYYY')));
        iaProgramarileDinZiua(Zi.format('DD/MM/YYYY'));
        });
    $('#adaugaProgramareOra').on('shown.bs.modal', function(e) {
        var ora = $(e.relatedTarget).data('ora');
        var minut = $(e.relatedTarget).data('minut');
        //$(e.currentTarget).find('input[name="ora"]').val(ora+":"+minut);
        console.log($('#adaugaProgramareOraLabel').text());
        $('#adaugaProgramareOraLabel').html('Adaugă o programare la ora '+ora+":"+minut);
        });

    $('#maine').on('click', function(e){ 
        var Zi = moment($('#programariPicker').val(), "DD/MM/YYYY");
        Zi.add(1, 'days');
        $('#programariPicker').val((Zi.format('DD/MM/YYYY')));
        iaProgramarileDinZiua(Zi.format('DD/MM/YYYY'));
    });
    listen_for_events($("#timestamp").val());
        });
