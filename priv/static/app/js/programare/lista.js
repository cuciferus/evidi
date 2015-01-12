        function iaAzi() {
            d1 = new Date();
            return d1.getDate() +'/'+(d1.getMonth()+1) + '/' +d1.getFullYear();
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
                    $.getJSON("/programares/listaZI/"+dataZi, function(jd){
                        var programari = jd.programari;
                        console.log(programari.length);
                        if (programari.length != 0) {
                            for (var i=0; i< programari.length; i++){
                            console.log('ora programarii e '+programari[i].ora.split(":"));
                            $.getJSON('/pacient/cauta/'+programari[i].pacient_id, function(jd){
                                [zi,luna, an] = programari[i-1].data.split("/");
                                [ora, minut] = programari[i-1].ora.split(":");// nici ora de inceput nu apare bine....pzdm
                                var d1 = new Date(an, luna, zi);
                                d1.setHours(ora); //poate merge mai elegant though
                                d1.setMinutes(minut);
                                var d2 = new Date(d1);
                                $('#programari-list tbody').append('<tr><td> '+ programari[i-1].ora +'</td><td> '+ d2.getHours()+ ":"+ d2.getMinutes() +'</td><td>'+ jd.pacient.nume+'</td><td>'+ jd.pacient.prenume +'</td><td><a href="/consults/adauga/"'+jd.pacient.id+'/'+programari[i-1].id +' class="btn btn-primary"> Adauga consult</a></td></tr>');
                            });
                            }
                        }
                        else {
                        $('#programari-list tbody').append('<tr><td> Nu ai programari</td><td> Go Home </td></tr>'); //sa poate mai bine
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

    listen_for_events( $("#timestamp").val());
            });
