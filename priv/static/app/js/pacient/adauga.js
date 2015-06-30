function populeazaTari() {
    $.getJSON('/adresa/lista_tari', function(jd) {
            var tari = jd.tari;
            for (var i=0;i<tari.length; i++) {
            var tara = '<option value="'+ tari[i].cod+'">'+tari[i].nume+'</option>';
            $('#tara').append(tara);
            }
            });
};

function populeazaOrase(Judet){
    $.getJSON('/adresa/populeaza_orase/'+Judet+'/', function(jd) {
            $("#oras").prop("disabled", false);
            var orase = jd.orase;
            $("#oras option").remove();
            for (var i=0; i<orase.length;i++) {
            $("#oras").append('<option value="'+orase[i].id+'">'+orase[i].nume+'</option>');
            }
            });
};

function populeazaJudete(Tara){
    $.getJSON('/adresa/populeaza_judete/'+Tara+'/', function(jd){
            var judete = jd.judete;
            $("#judete option").remove();
            for (var i=0; i< judete.length; i++){
            $("#judete").append('<option value="'+judete[i].id+'">'+ judete[i].nume+'</option>');
            }
            });
};

  
$("#strada").typeahead({ 
    source: function(request, process) {
    $.ajax({
            url:"/adresa/cauta_strada/"+$("#oras").val()+"/"+request,
            dataType: "json",
            success: function(data) {
            console.log(data);
            return process(data.strazi);}
            })},
    displayText: function(item){
    return item.nume;
    },
    items:3});


$("#tara").change(function() {
        populeazaJudete($('#tara').val());
        });

$("#strain").change(function() {
        if ($("#strain").prop('checked')==true) {
            $("#tara").prop("disabled", false);
            };
        });

$("#provincie").change(function() {
        if ($("#provincie").prop('checked') == true) {
        $("#judete").prop("disabled", false);
        populeazaJudete("salut");
        };
        });

$("#judete").change(function() {
            populeazaOrase($('#judete').val());
                    });


$("#adaugaPacientModal").on("submit", function(e){
    e.preventDefault();
    var submitButton = $(this);
    var form = $("#adaugaPacientModal form");
    var formData = form.serialize();
    console.log(formData);
    $.ajax({
        url: "/pacient/adauga/",
        type: "POST",
        data: formData,
        error: function(data) {
            alert(data)
        },
        sucess: function(data) {
                $("#adaugaPacientModal").modal('hide');
            }
        })
    $("#adaugaPacientModal").modal('hide')
    });



