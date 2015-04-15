"use strict";
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
            var capitol = '<option value="'+capitole[i].cod+'">'+capitole[i].capitol+'</option>';
            $('#cim10capitole').append(capitol);
            }
        });
};

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

function genereazaCnp() {
    $.ajax("/icd/genereazaCnp/",{ success:
           function(data, code, xhr){
               $("#cnpRezult").val(data.cnp);
    }});
};

function genereazaAn() {
    var An = Math.floor(Math.random() *100);
    return padeazaAn(An);
};
function genereazaAnSecoluNostru() {
    var An = new Date().getFullYear();
    var CifreAn = Math.floor(An%100);
    var AnNou = Math.floor(Math.random()*CifreAn);
    return padeazaAn(AnNou);

};

function padeazaAn(An) {
    if (An<10) {
        return "0"+An;
    } else {
        return An
    };
};

function e_an_bisect(An) {
    return !(( An%4) || (!(An % 100) && (An %400)));
};

function unuSauDoi(Lista) {
    var randomIndex = Math.floor(Math.random()*2);
    return Lista[randomIndex]
};

function genereazaCifreJudet(Judete) {
        var keys = Object.keys(Judete)
        return Judete[keys[ keys.length * Math.random() << 0]];
};

           

function genereazaSex(An) {
    switch (An) {
        case "18":
            return unuSauDoi(["3","4"]);
        case "19":
            return unuSauDoi(["1","2"]);
        case "20":
            return unuSauDoi(["5","6"]);
    };
};

var judete = {
    Alba: "01",
    Arad: "02",
    Argeş: "03",
    Bacău: "04",
    Bihor: "05",
    BistriţaNăsăud: "06",
    Botoşani: "07",
    Braşov: "08",
    Brăila: "09",
    Buzău: "10",
    CaraşSeverin: "11",
    Cluj: "12",
    Constanţa: "13",
    Covasna: "14",
    Dâmboviţa: "15",
    Dolj: "16",
    Galaţi: "17",
    Gorj: "18",
    Harghita: "19",
    Hunedoara: "20",
    Ialomiţa: "21",
    Iaşi: "22",
    Ilfov: "23",
    Maramureş: "24",
    Mehedinţi: "25",
    Mureş: "26",
    Neamţ: "27",
    Olt: "28",
    Prahova: "29",
    SatuMare: "30",
    Sălaj: "31",
    Sibiu: "32",
    Suceava: "33",
    Teleorman: "34",
    Timiş: "35",
    Tulcea: "36",
    Vaslui: "37",
    Vâlcea: "38",
    Vrancea: "39",
    Bucureşti: "40",
    Sector1: "41",
    Sector2: "42",
    Sector3: "43",
    Sector4: "44",
    Sector5: "45",
    Sector6: "46",
    Călăraşi: "51",
    Giurgiu: "52"
};
function genereazaNnn() {
    var nnn = Math.floor(Math.random() * 999);
    if (nnn < 10) {
         return "00"+nnn;
    } else if (nnn<100) {
        return "0" + nnn;
    }
    else {
        return nnn;
    };
};

function genereazaC(Cnp) { //pam-pam
    var fix = "279146358279".split("");
    var Cnp = Cnp.split("");
    var cfinal=[];
    var c = fix.map(function (e, i) {//e pare element si i index
        var cifra = parseInt(fix[i])*parseInt(Cnp[i]); 
        cfinal.push(cifra); 
    })
    var total =0;
    $.each(cfinal, function(){
        total += this;
        return total;
    });
    if (Math.floor(total % 11) == 10) {
        return 1;
    } else {
        return Math.floor(total % 11);};
};
function genereazaZi(An, Luna){//should work
    if ($.inArray(Luna, [1,3,5,7,8,10,12]) > -1)
        { 
        return padeazaAn(Math.floor(Math.random()*31)+1);
    } else 
        { if (Luna !=2){
            return padeazaAn(Math.floor(Math.random()*30)+1);
        } else {
            if (e_an_bisect(An)) {
                return padeazaAn(Math.floor(Math.random()*29)+1);
            } else {
                return padeazaAn(Math.floor(Math.random()*28)+1);
            };
        };
        };
};


function generareCifreAn(cifreAn) {
    if ($.inArray(cifreAn, ["18","19"]) > -1) {
        return genereazaAn();
    } else {
        return genereazaAnSecoluNostru();
    }
};
    



function generareCnp() { 
    var lista = ["18", "19", "20"];
    var randomIndex = Math.floor(Math.random() * lista.length);
    var cifreAn = lista[randomIndex];
    var An = generareCifreAn(cifreAn);
    var Luna = Math.floor(Math.random()*12)+1;
    var Zi = genereazaZi(An, Luna);
    var Luna = padeazaAn(Luna);
    var Sex = genereazaSex(cifreAn);
    var Judet = genereazaCifreJudet(judete);
    var Nnn = genereazaNnn();
    var PrimeleCifre = [Sex,An,Luna,Zi,Judet,Nnn];//Nnn apare alta e eroarea
    var PrimeleCifre = PrimeleCifre.join('');
    var C = genereazaC(PrimeleCifre); 
    var Cnp = PrimeleCifre+C;
    $("#cnpRezult").val(Cnp);
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
        $('#genereazacnp').on('click', function() {
            generareCnp();});
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


