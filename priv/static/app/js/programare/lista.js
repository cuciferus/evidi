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
    iaProgramarileDinZiua(formateazaZiua(d1.getDate() +'/'+(d1.getMonth()+1) + '/' +d1.getFullYear()));
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
        $('#programari-list tbody').empty();
        if (programari.length !=0){
            for (var i=0; i<programari.length; i++) {
                $('#programari-list tbody').append('<tr><td> '+ programari[i].ora +'</td><td> '+ programari[i].durata + '</td><td>'+ pacienti[i].nume+'</td><td>'+ pacienti[i].prenume +'</td><td><a href="/consults/adauga/"'+pacienti[i].id+'/'+programari[i].id +' class="btn btn-primary"> Adauga consult</a></td></tr>');
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

    
            listen_for_events( $("#timestamp").val());
                });
