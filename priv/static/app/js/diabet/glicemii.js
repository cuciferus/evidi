var data = {
    labels: ["01", "02", "03", "04", "05", "06", "07"],
    datasets: [
        
        {
            label: "My Second dataset",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [28, 48, 40, 19, 86, 27, 90]
        }
    ]
};


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
}

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





$(document).ready(function() {
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
        console.log('datele trimise sunt '+formData);
        $.ajax({
            url:"/diabet/adaugaGlicemie/"+pacientid ,
            type: "POST",
            data: $('#adaugaGlicemiiForm').serialize(),
            error: function(eroare) {
                console.info(data);
            },
            success: function(data){
                console.log("gata cu data"+data);
            }
        });
    });
    moment().format();
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

    var ctx = document.getElementById("graficGlicemii").getContext("2d");
    var graficGlicemii = new Chart(ctx).Line(data, {});


    


});
