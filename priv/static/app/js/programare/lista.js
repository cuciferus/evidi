"use strict";
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
var calls = 0;
function iaProgramarileDinZiua(zi){
    return $.ajax({
        url:"/programares/listaZI/"+zi,
        dataType:"json", 
        success: function(data){
            faTabeluDeprogramari2(data,zi);//sau aici eventual un caz pentru care nu ai programari
        }
    })
};


function formateazaProgramarile(programari) {
    for (var i=0; i<programari.length;i++) {
        programari[i].ora = moment(programari[i].ora.split("T")[1].slice(0,-1),"HH:mm:ss");
    }
    return programari;
};

function formateazaProgramarile2(programari) {
    for (var i=0; i< programari.length; i++){
        programari[i] = moment(programari[i], "HH, mm, ss");
    };
    console.log(programari);
    return programari;
};


function getMultiplier(durata_programare){
    var result=0;
             if ((durata_programare%15)==0 )
                    {
                        result=(durata_programare/15);
                    }
                        else
                    {
                            result=Math.floor(durata_programare/15)+1;
                    }
    return result;
}

function faTabeluDeprogramari2(programariSiPacienti, zi) {
    $('#programari-list tbody').empty();
    console.log(programariSiPacienti.orele);

    var ora_deschidere = moment();
    ora_deschidere.hour(9); ora_deschidere.minute(0);ora_deschidere.seconds(0);//aici va fi ora deschiderii programului
    var ora_inchidere = moment();
    ora_inchidere.hour(13); ora_inchidere.minute(0);ora_inchidere.seconds(0);//ora inchiderii programului
    var ora_momentului = ora_deschidere;
    var ora_bkp=moment();
   var ora_baza=moment();


    var programariNeformatate =[
                      {
                        "id": "programare-12",
                        "data": "2033-11-07T18:13:28Z",
                        "ora": "2015-08-10T10:01:01.000Z",
                        "durata": 48,
                        "pacient_id": "pacient-4"
                      },
                      {
                        "id": "programare-11",
                        "data": "2033-11-07T18:13:28Z",
                        "ora": "2015-08-10T11:15:01.000Z",
                        "durata": 13,
                        "pacient_id": "pacient-4"
                      },
                      {
                        "id": "programare-10",
                        "data": "2033-11-07T18:13:28Z",
                        "ora": "2015-08-10T12:30:01.000Z",
                        "durata": 13,
                        "pacient_id": "pacient-4"
                      }
                    ]
    var pacienti = programariSiPacienti.pacienti;
    var programari = formateazaProgramarile2(programariSiPacienti.orele);
    var nr_programari = 0;
    var multiplier=0;
    while (moment.min(ora_momentului, ora_inchidere) < ora_inchidere) 
    {  //mda e greșit
        ora_baza.hour(ora_momentului.hour());
        ora_baza.minute(ora_momentului.minute());
        ora_baza.seconds(ora_momentului.seconds());


        ora_bkp.hour(ora_momentului.hour());
        ora_bkp.minute(ora_momentului.minute());
        ora_bkp.seconds(ora_momentului.seconds());



        console.log('ora moment');
        console.log(ora_momentului.minute());
                console.log('ora bkp');
        console.log(ora_bkp.minute());
                console.log('next minute');
        //console.log(programari[nr_programari].ora.minute());

        if (nr_programari<programari.length){ 
            if (ora_momentului == programari[nr_programari].ora){
                console.log('intra 1');
                $('#programari-list tbody').append('<tr><td>'+ ora_momentului.hour()+":"+ora_momentului.minute()+
                           '</td><td>'+programari[nr_programari].pacient_id +' '+ programari[nr_programari].pacient_id+'</td><td> '+ programari[nr_programari].durata +'</td></tr>');

                 multiplier=getMultiplier(programari[nr_programari].durata);
                ora_momentului.add(multiplier*15,'m');

                nr_programari = nr_programari+1;
            } else if (moment.min(ora_momentului,programari[nr_programari].ora)==ora_momentului && moment.min(ora_bkp.add(15,'m'),programari[nr_programari].ora)==programari[nr_programari].ora  &&  ora_bkp!==programari[nr_programari].ora && ora_momentului!==programari[nr_programari].ora) {
                //(moment.min(ora_bkp.add(15,'m'), programari[nr_programari].ora) == programari[nr_programari].ora)
                console.log('intra 2');
                $('#programari-list tbody').append('<tr><td>' + ora_momentului.hour() +":"+ ora_momentului.minute()+
                                                   '</td><td> timp mort</td><td> aici ieși la o țigară</td></tr>');
                $('#programari-list tbody').append('<tr><td>' + programari[nr_programari].ora.hour()+":"+programari[nr_programari].ora.minute()+
                                                   '</td><td>'+programari[nr_programari].pacient_id +' '+ programari[nr_programari].pacient_id+'</td><td> '+ programari[nr_programari].durata +'</td></tr>');
                var pauza = programari[nr_programari].ora.subtract({hours: ora_momentului.hour(), minutes: ora_momentului.minutes()});
                //ora_momentului.add({hours: pauza.hour(), minutes: pauza.minutes()});
                console.log('pauza');
                console.log(pauza);
                multiplier=getMultiplier(programari[nr_programari].durata+pauza.minute());
                ora_momentului.add(multiplier*15,'m');
                ora_bkp.hour(ora_momentului.hour());
                ora_bkp.minute(ora_momentului.minute());
                ora_bkp.seconds(ora_momentului.seconds());
                nr_programari = nr_programari+1;
            } else {
                console.log('intra 3');
                console.log(ora_bkp);
                console.log(ora_momentului);
                $('#programari-list tbody').append('<tr><td> '+ ora_momentului.hour()+':'+ ora_momentului.minute()+
                    '</td><td> <button type="button" class="btn btn-info" data-toggle="modal" data-target="#adaugaProgramareOra" data-ora="'
                    +ora_momentului.hour()+'" data-minut="'+ ora_momentului.minute() +'"> Adaugă programare</button></td><td>scopul/durata/cnp</td></tr>');
                ora_momentului.add(15,'m');
            }
        } else {
            console.log('intra 4');
            console.log('intra aici');
            $('#programari-list tbody').append('<tr><td> '+ ora_momentului.hour()+':'+ ora_momentului.minute()+
                '</td><td> <button type="button" class="btn btn-info" data-toggle="modal" data-target="#adaugaProgramareOra" data-ora="'
                +ora_momentului.hour()+'" data-minut="'+ ora_momentului.minute() +'"> Adaugă programare</button></td><td>scopul/durata/cnp</td></tr>');
            ora_momentului.add(15,'m');
                    console.log('intra aici 2');
        }
        console.log('ora dupa');
        console.log(ora_momentului);
    }
};


    

$(document).ready(function () {
    moment().format();
    var azi = moment().format('DD/MM/YYYY');
    $('#programariPicker').val(azi);
    iaProgramarileDinZiua(azi);
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
