"use strict";
var data = {
    labels:["Ianuarie", "Febroarie", "Martie", "Aprilie", "May", "Iunie"],
    datasets: [
    {
        label: "Primu grafic",
        fillColor: "rgba(220,220,220,0.2)",
        strokeColor: "rgba(220,220,220,1)",
        pointColor: "rgba(220,220,220,1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        data: [0.5,0.7,1,1.3.,0.7,0.2]
    }
    ]
}
$(document).ready(function(){
    var canvas = document.getElementById("grafic-medical");
    var ctx = canvas.getContext("2d");
    new Chart(ctx).Line(data, options);
}
