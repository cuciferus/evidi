function listen_for_events(timestamp) {
    $.ajax("/pacient/pull/"+timestamp, { success:
        function(data, code, xhr) {
            for (var i=0; i< data.pacienti.length; i++){
                var msg= data.pacienti[i].nume;
                console.log('ai editat pa '+ msg);
            }
            listen_for_events(data.timestamp);
        }
    });
};

function cautaCnp(cnp) {
    $.getJSON("/pacient/cautaCnp/*"+cnp+ "*", function(jd) {
        $("#pacienti tbody").empty()
        var pacienti = jd.pacienti;
        if (pacienti.length==0) {
            $("#pacienti tbody").append('<tr><td> Acest pacient nu egsita poti sa-l adaugi folosind butonul de langa<td> <button type="button" class="btn btn-primary"> Adauga pacient</button></td></tr>');
        } else {
            for (var i=0; i<pacienti.length; i++){
                $("#pacienti tbody").append('<tr><td>'+pacienti[i].nume +'</td><td>'+ pacienti[i].prenume +'</td><td>'+ pacienti[i].cnp + '</td><td>'+
        '<td><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#adaugaProgramare" data-pacientid='+ pacienti[i].id +'> Adauga programare</a></td><td><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#editeazaPersonale" data-pacientid='+ pacienti[i].id +'> Editeaza date personale</button></td><td><a href="{% url action="adaugapersonala" id=pacient.id %}"> Adauga şi boli</a> </td></tr>');
                }
            }
        });

};

function cautaNume(nume) {
    $.getJSON("/pacient/cautaNume/*"+nume+"*", function(jd){
        var pacienti =jd.pacienti;
        for (var i=0; i<pacienti.length; i++){
            $("#pacienti tbody").html('<tr><td>'+pacienti[i].nume +'</td><td>'+ pacienti[i].prenume +'</td><td>'+ pacienti[i].cnp + '</td><td>'+
        '<td><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#adaugaProgramare" data-pacientid='+ pacienti[i].id +'> Adauga programare</a></td><td><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#editeazaPersonale" data-pacientid='+ pacienti[i].id +'> Editeaza date personale</button></td><td><a href="{% url action="adaugapersonala" id=pacient.id %}"> Adauga şi boli</a> </td></tr>');
        }
    });
};

function afiseazaToti() {
    $.getJSON("/pacient/listaToti/", function(jd){
        $("#pacienti tbody").empty();
        var pacienti = jd.pacienti;
        for (var i=0; i<pacienti.length; i++){
            $("#pacienti tbody").append('<tr><td>'+pacienti[i].nume +'</td><td>'+ pacienti[i].prenume +'</td><td>'+ pacienti[i].cnp + '</td><td>'+
        '<td><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#adaugaProgramare" data-pacientid='+ pacienti[i].id +'> Adauga programare</a></td><td><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#editeazaPersonale" data-pacientid='+ pacienti[i].id +'> Editeaza date personale</button></td><td><a href="{% url action="adaugapersonala" id=pacient.id %}"> Adauga şi boli</a> </td></tr>');
                        }
                          })
};



$(document).ready(function() {
    $('#dataprogramarii').datetimepicker({
        language: 'ro',
        sideBySide: true,
        daysOfWeekDisabled: [0,1,5,6]
        });
        $("#cautareCnp").keyup(function(e){
            var search_string = $(this).val();
        if(search_string.length >=3) {
            cautaCnp(search_string);
        } else if(search_string.length ==0){
            afiseazaToti();
            }
        return false;
        });
    $("#searchclear").click(function() {
        $("#cautaNume").val('');
        });

    $("cautareNume").keyup(function(e){
        var search_string = $(this).val();
        if(search_string.length >=3){
            cautaNume(search_string);
        } else if(search_string.length ==0){
            afiseazaToti();
        }
        return false;
        });
    listen_for_events($("#timestamp").val());
});


