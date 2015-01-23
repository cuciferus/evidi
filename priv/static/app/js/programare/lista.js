function listen_for_events(timestamp) {
        $.ajax("/programares/pull/"+timestamp, { success: //adaugare in lista doar daca programarea e din ziua respectiva
                function(data, code, xhr) {
                for (var i=0; i< data.programari.length; i++) {
                    var programare = data.programari[0];
                    $.getJSON('/pacient/cauta/'+programare.pacient_id, function(jd) {
                    $("#programari-list").append(
                        '<tr><td> '+ programare.ora + ' </td> <td> '+ jd.pacient.nume+'</td> <td>'+ jd.pacient.prenume +'</td> <td><a href="/consults/adauga/"'+jd.pacient.id+'/'+ programare.id+' class="btn btn-primary"> Adauga consult</a></td> </tr>'
                        );
                        });
                }
            listen_for_events(data.timestamp);
                } });
    };
       
function iaAzi() {
    d1 = new Date();
    return formateazaZiua(d1.getDate() +'/'+(d1.getMonth()+1) + '/' +d1.getFullYear());
};

function calculeazaOraFinala(timp, durata) {
    console.log(timp);//acum aici am timpu altfel cre ca trebe rescris putin
    [ora, minut] = timp.split(":");
    d1 = new Date();
    d1.setHours(ora);
    d1.setMinutes(Number(minut)+Number(durata));
    return ''+d1.getHours() + ":"+d1.getMinutes();
};
function formateazaZiua(zi) { 
    [zi, luna, an] = zi.split("/");
    zi = zi<10? '0'+zi:''+zi;
    luna = luna<10? '0'+luna:''+luna;
    return [zi,luna,an].join("/");
};

function iaProgramarileDinZiua(zi){
    $.getJSON("/programares/listaZI/"+zi, function(jd){
        var programari = jd.programari;
        var pacienti = jd.pacienti;
        if (programari.length !=0){
            for (var i=0; i<programari.length; i++) {
                $('#programari-list tbody').append('<tr><td> '+ programari[i].ora +'</td><td> '+ calculeazaOraFinala(programari[i].ora, programari[i].durata) + '</td><td>'+ pacienti[i].nume+'</td><td>'+ pacienti[i].prenume +'</td><td><a href="/consults/adauga/"'+pacienti[i].id+'/'+programari[i].id +' class="btn btn-primary"> Adauga consult</a></td></tr>');
            }}
            else {
                console.log('nu ai programari'); //de facut mai calumea
            }
    });
}







        $(document).ready(function () {
            $('#programariPicker').val(iaAzi());
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
                    [zi, luna, an] = $('#programariPicker').val().split("/");
                    d1 = new Date();
                    d1.setYear(an);
                    d1.setMonth(luna);
                    d1.setDate(zi-1);
                    $('#programariPicker').val(formateazaZiua(d1.getDate()+'/'+d1.getMonth()+'/'+d1.getFullYear()));
                    iaProgramarileDinZiua($('#programariPicker').val());
                    });

            $('#maine').on('click', function(e){ //asta nu merge
                [zi, luna, an] = $('#programariPicker').val().split("/");
                d1 = new Date();
                d1.setYear(an);
                d1.setMonth(luna);
                d1.setDate(zi+1);
                $('#programariPicker').val(formateazaZiua(d1.getDate() +'/'+d1.getMonth()+'/'+d1.getFullYear()));
                iaProgramarileDinZiua($('#programariPicker').val());
            });

    
            listen_for_events( $("#timestamp").val());
                });
