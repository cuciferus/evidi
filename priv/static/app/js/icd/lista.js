function veziSelect(evt) {
            var val = $("input[name=icdselect]:checked").val();
            window.tipCod = val;
            };

function cautaCim(diagnostic) {
    $.getJSON('/cim/cauta/*'+diagnostic+'*', function(jd) {
        var coduri = jd.diagnostice;
        if (coduri.length ==0) {
            $('#coduri-list tbody').append('<tr><td> Nu exista boala pe care o cauti</td><td></td></tr>');
        } else {
            for (var i=0; i<coduri.length; i++) {
            $('#coduri-list tbody').append('<tr><td>'+ coduri[i].nume+'</td><td>'+coduri[i].cod+'</td></tr>');
            }
            }
            });
            };


function cautaIcd(diagnostic) {
    $.getJSON('/icd/cauta/*'+diagnostic+'*', function(jd) {
        var coduri = jd.diagnostice;
        if (coduri.length ==0) {
            $('#coduri-list tbody').append('<tr><td> Nu exista boala pe care o cauti</td><td></td></tr>');
        } else {
            for (var i =0; i< coduri.length; i++) {
                $('#coduri-list tbody').append('<tr><td>'+ coduri[i].diagnostic+'</td><td>'+ coduri[i].cod+'</td></tr>');
                }
            }
        });
    };

function populeazaCapitole() {
    $.getJSON('/cim/capitole/', function(jd) {
        var capitole = jd.capitole;
        for (var i=0; i < capitole.length; i++) {
            capitol = '<option value="'+capitole[i].cod+'">'+capitole[i].capitol+'</option>';
            $('#cim10capitole').append(capitol);
            }
        });};

function populeazaSubcapitole(Capitol) {
    $.getJSON('/cim/subcapitole/'+Capitol+'/', function(jd) {
        var subcapitole = jd.subcapitole;
        $('#cim10subcapitole option').remove();
        for (var i=0; i< subcapitole.length; i++){
            $('#cim10subcapitole').append('<option value="'+subcapitole[i].cod+'">'+subcapitole[i].nume+'</option>');
            }
        });
        };

function populeazaEntry(Subcapitol) {
    $('#coduri-list tbody').empty();
    $.getJSON('/cim/entry/'+Subcapitol+'/', function(jd) {
        var coduri = jd.coduri;
        for (var i=0; i<coduri.length; i++) {
            $('#coduri-list tbody').append('<tr><td>'+coduri[i].nume+'</td><td>'+coduri[i].cod+'</td></tr>');
            }
        });
        };

$(document).ready(function(){
        $('input[name=icdselect]:radio').change(veziSelect);
        $('#cim10capitole').change(function() {
            populeazaSubcapitole($('#cim10capitole').val());
            });
        $('#cim10subcapitole').change(function() {
            populeazaEntry($('#cim10subcapitole').val());
            });
        veziSelect();
        populeazaCapitole();
        $('#cautareDiagnostic').keyup(function(e){ 
            var diagnostic = $(this).val();
            if (diagnostic.length >=3){
                $('#coduri-list tbody').empty();
                if (window.tipCod == 'icd10') {
                    cautaIcd(diagnostic);
                    } else {
                    cautaCim(diagnostic);}
                };
            });
        });


