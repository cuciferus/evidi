
var glicemii = [];
var data = [];

function loadWeather(location, woeid){
    $.simpleWeather({
        location: location,
        woeid:woeid,
        unit: 'c',
        success: function(weather){
            html='<p>'+ weather.temp + ' grade' + weather.units.temp + '</p>';
            $("#weather").html(html);
            gaseste_sport_pentru_tip_vreme(weather.code)
        },
        error: function(error){
            $("weather").html('<p>'+error+'</p>');
        }
    }); 
};
function calculeazaSexul(Cifra) {
    switch(Cifra){
        case "1":
        case "3":
        case "5":
        case "7":
            return "barbat";
            break;
        case "2":
        case "4":
        case "6":
        case "8":
            return "femeie";
            break;
        case "9":
            return "străin";
            break;
    };
};

function calculeazaNecesarulCaloric(BMR) {
    switch ($('#activitate-fizica').val()){
        case "1":
            return BMR*1.2;
            break;
        case "2":
            return BMR*1.375;
            break
        case "3":
            return BMR*1.55;
            break;
        case "4":
            return BMR*1.725;
            break;
        case "5":
            return BMR*1.9;
            break;
    };
};

function gaseste_sport_pentru_tip_vreme(cod_vreme){
    switch (parseInt(cod_vreme)) {
        case 0: //tornado
        case 1: //tropical storm
        case 2: //hurricane
        case 3://severe thunderstorms
        case 4: //thunderstorms
            $("#recomandare-sport").replaceWith("<p> fugi din calea furtunii</p>");
            break;
        case 5: //mixed rain and snow
        case 6://mixed rain and sleet
        case 7://mixed snow and sleet
        case 8://freezing drizzle
        case 9://drizzle
        case 10://freezing rain
            $("#recomandare-sport").replaceWith("<p> Box, MMA sau alte sporturi practicabile la tine în casă</p>");
            break;
        case 11://showers
        case 12://showers
        case 13://snow flurries
        case 14://light snow showers
            $("#recomandare-sport").replaceWith("<p> Afară ploua e întuneric; recomandăm sex</p>");
            break;
        case 15://blowing snow
        case 16://snow
            $("#recomandare-sport").replaceWith("<p> Făcut oameni de zăpadă, sky</p>");
            break;
        case 17: //hail
        case 18: //sleet
            $("#recomandare-sport").replaceWith("<p> Flotări</p>");
            break;
        case 19: //dust
        case 20: //foggy
        case 21://haze
        case 22: //smoky
            $("#recomandare-sport").replaceWith("<p> Darts</p>");
            break;
        case 23: //blustery
        case 24: //windy
            $("#recomandare-sport").replaceWith("<p> iachting, wind surfing</p>");
            break;
        case 25: //cold
            $("#recomandare-sport").replaceWith("<p> hot tubbing</p>");
            break;
        case 26: //cloudy
        case 27: //mostly cloudy(night)
        case 28://mostly cloudy(day)
        case 29: //party cloudy(night)
        case 30: //partly cloudy(day)
            console.log("am ajuns unde trebuie");
            $("#recomandare-sport").replaceWith("<p> bird-watching</p>");
            break;
        case 31: //clear(night)
            $("#recomandare-sport").replaceWith("<p> rape</p>");
            break;
        case 32: //sunny
            $("#recomandare-sport").replaceWith("<p> jogging, bronzat, mers în parc</p>");
            break;
        case 33: //fair(night)
        case 34: //fair(day)
            $("#recomandare-sport").replaceWith("<p> flotări, genoflexiuni</p>");
            break;
        case 35: //mixed rain and hail
            $("#recomandare-sport").replaceWith("<p> seeeeex</p>");
            break;
        case 36: //hot
            $("#recomandare-sport").replaceWith("<p> înot, mers prin pădure</p>");
            break;
        case 37: //isolated thunderstorms
        case 38: //scattered thunderstorms
        case 39: //scattered thunderstorms
            $("#recomandare-sport").replaceWith("<p> cântat în ploaie</p>");
            break;
        case 40: //scattered showers
            $("#recomandare-sport").replaceWith("<p> mers cu cățelu sub umbrelă</p>");
            break;
        case 41: //heavy snow
        case 42: //scattered snow showers
        case 43: //heavy snow
            $("#recomandare-sport").replaceWith("<p> sky, dat la lopată zăpada din fața casei</p>");A
            break;
        case 44: //partly cloudy
        case 45: //thundershowers
        case 46: //snow showers
        case 47: //isolated thundershowers
            $("#recomandare-sport").replaceWith("<p> mutat mobila</p>");
            break;
        case 3200://not available
            $("#recomandare-sport").replaceWith("<p> nu pot afla vremea în localitatea definită, uită-te pe geam și spune-mi cum e</p>");
            break;
        default: console.log("nu intră nicăieri");
    };
};

function iaVarstaSiSexulDinCnp(Cnp) {
    var dataNastere = moment(Cnp.substr(1,6), "YYMMDD");
    var azi = moment();
    var varsta = azi.subtract({year: dataNastere.year(), month: dataNastere.month()}).years();
    return varsta;
}

function calculeazaBMR(Sex, Greutate, Inaltime, Varsta) {
    var GreutateInt = parseInt(Greutate);
    var InaltimeInt = parseInt(Inaltime);
    var VarstaInt = parseInt(Varsta);
    if (Sex=="feminin") {
        var BMRFemeie = 655+(9.6*Greutate)+(1.8*Inaltime)-(4.7*Varsta);
        return BMRFemeie;
    }
    else if (Sex=="barbat"){
        var BMRBarbat = 66+(13.7*GreutateInt)+(5*InaltimeInt)-(6.8*VarstaInt);
        return BMRBarbat;
    } else {
        console.log("nu am sex")

    }
};


function iaGlicemiile() {

    $.ajax({
        dataType:"json",
        url: "/diabet/listaGlicemiilor/"+$('#pacientid').val(),
        success: function(rezultat){
            for (var i=0;i<rezultat.glicemii.length;i++) {
                glicemii.push(rezultat.glicemii[i].glicemie);
                data.push(rezultat.glicemii[i].data.split("T")[0]);
            };
            deseneazaGrafic(glicemii,data);
        }
    });
};

function deseneazaGrafic(glicemii, dati){
    var data = {
        labels:dati,
        datasets: [
            {
                label: "Glicemii in diverse zile",
                fillColor: "rgba(220,220, 220,0.2)",
                strokeColor: "rgba(151,187, 205, 1)",
                pointColor: "rgba(151,187, 205,1)",
                pointStrokeColor: "#fff",
                poingHighlightFill:"#fff",
                pointHighStroke:"rgba(151,187,205,1)",
                data: glicemii
            }
        ]
    };
     var ctx = document.getElementById("graficGlicemii").getContext("2d");
    var graficGlicemii = new Chart(ctx).Line(data, {});
};


    $(document).ready(function() {
        iaGlicemiile();
    var azi = moment().format('DD/MM/YYYY');
    $('#dataglicemie').val(azi);
    $('#dataglicemie').datetimepicker({
            pickTime: false,
            language: "ro",
            useCurrent: true,
            });

    $("#adaugaGlicemie").on('click', function(e){
        e.preventDefault();
        var submitButton = $(this);
        var pacientid=$('#pacientid').val();
        var form = $('#adaugaGlicemiiForm');
        var formData = form.serialize();
        $.ajax({
            url:"/diabet/adaugaGlicemie/"+pacientid ,
            type: "POST",
            data: $('#adaugaGlicemiiForm').serialize(),
            error: function(eroare) { //dintrun motiv sau altul primesc 404 dupa
                form[0].reset();
                glicemii.push($('#glicemie').val());
                data.push($('#dataglicemie').val());
                deseneazaGrafic(glicemii,data);
            },
            success: function(data){
                form[0].reset();
                glicemii.push($('#glicemie').val());
                data.push($('#dataglicemie').val());
                deseneazaGrafic(glicemii,data);

            }
        });
    });

    $("#calculeazacalorii").on('click', function(e){
        e.preventDefault();
        var submitButton = $(this);
        var Cnp = $('#pacientcnp').val();
        var Sex = calculeazaSexul(Cnp[0]);
        var Inaltime = $('#inaltime').val();
        var Varsta = iaVarstaSiSexulDinCnp(Cnp);
        var Greutate = $('#greutate').val()
        var BMR = calculeazaBMR(Sex, Greutate, Inaltime, Varsta);
        var necesarCaloric = calculeazaNecesarulCaloric(BMR);
        if ($('#boalacronica').is(':checked')){
        $('#necesar-caloric').replaceWith('<p id="necesar-caloric"> Necesarul caloric zilnic este '+necesarCaloric*1.3+' calorii. <br/> Eventual sfaturi despre slabit </p>');
        } else {
        $('#necesar-caloric').replaceWith('<p id="necesar-caloric"> Necesarul caloric zilnic este '+necesarCaloric+' calorii. <br/> Eventual sfaturi despre slabit </p>');
        }

    }
                              );
    $("#data-analiza").datetimepicker({
        pickTime: false,
        language:"ro",
        useCurrent: true});


    loadWeather('Bucharest','');
    if ("geolocation" in navigator) {
        console.log('are posibilitate de detectie a locatiei;');
    } else {
        console.log('trebuie sa introducă locația manual');
    };

    $("#geolocation").on('click', function()
                         { navigator.geolocation.getCurrentPosition(function(position){
                             loadWeather(position.coords.latitude+','+position.coords.longitude);

                         });
                     });

    
    $("#zilnic").click(function() {
        $("#protocol").replaceWith("<div> protocol zilnic</div>");
        console.log("salut baiete");
    });


    


});
