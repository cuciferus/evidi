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
    return d1.getDate() +'/'+(d1.getMonth()+1) + '/' +d1.getFullYear();
};





        $(document).ready(function () {
            $('#programariPicker').val(iaAzi());
            $('#programariPicker').datetimepicker({
                pickTime: false,
                language: "ro",
                useCurrent: true,
                }).on('dp.change', function (ev) {
                    $('#programari-list tbody').empty();
                    var dataZi = $('#programariPicker').val();
                    $.getJSON("/programares/listaZI/"+dataZi, function(jd){
                        var programari = jd.programari;
                        var pacienti = jd.pacienti;
                        if (programari.length !=0) {
                            for (var i=0; i<programari.length; i++){
                                $('#programari-list tbody').append('<tr><td> '+ programari[i].ora +'</td><td> '+ '</td><td>'+ pacienti[i].nume+'</td><td>'+ pacienti[i].prenume +'</td><td><a href="/consults/adauga/"'+pacienti[i].id+'/'+programari[i].id +' class="btn btn-primary"> Adauga consult</a></td></tr>');
                            }} else {
                                console.log('nu ai programari');
                            }
                    });
                        $(this).datetimepicker('hide');

                });


            $('#ieri').on('click', function(e){
                    [zi, luna, an] = $('#programariPicker').val().split("/");
                    var azi = new Date(an, luna, zi);
                    console.log(azi.getDay()); //sa apropie
                    console.log([azi.getDay()-1, azi.getMonth(), azi.getFullYear()].join("/"));

                    });

    
            listen_for_events( $("#timestamp").val());
                });
