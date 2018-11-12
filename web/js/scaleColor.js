/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


//draw SVG
var svg = d3.select("div#ascaleColor")
        .append("svg")
        .attr("height", h + pad.top + pad.bottom)
        .attr("width", w * 2 + pad.left + pad.right + pad.middle);


//draw panel for scale color
var scaleColorPlot = svg.append("g")
        .attr("id", "scaleColorPlot")
        .attr("transform", "translate(" + pad.left + "," + pad.top + ")");




//add the boxes around the panel
var drawEnclosures = function () {
    scaleColorPlot.append("text")
            .text("Correlation matrix")
            .attr("class", "main title")
            .attr("x", w / 2)
            .attr("y", -25);

};


//run the functions just created
drawEnclosures();