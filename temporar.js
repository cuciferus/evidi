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

