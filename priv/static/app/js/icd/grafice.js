
"use strict";
$(document).ready(function(){
    var data = 
            {
                labels: [],
                datasets: [
                    {
                        label: "My First dataset",
                        fillColor: "rgba(151,187,205,0.2)",
                        strokeColor: "rgba(151,187,205,1)",
                        pointColor: "rgba(151,187,205,1)",
                        pointStrokeColor: "#fff",
                        pointHighlightFill: "#fff",
                        pointHighlightStroke: "rgba(220,220,220,1)",
                        data: []
                    }
                                    ]
            };
    var ctx = document.getElementById("grafic-medical").getContext("2d");
    var hartaNoua = new Chart(ctx).Line(data);
    $('#adauga-valoare').click(function() {


        hartaNoua.addData([$('#valoare').val()], [$('#data-analiza').val()]);});
    $('#data-analiza').datetimepicker({
        startView: 2,
        minView: 3,
        pickTime: false,
        language: "ro"
        });

        });
