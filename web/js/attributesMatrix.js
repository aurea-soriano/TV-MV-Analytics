/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//draw SVG
var svg = d3.select("div#attributesMatrix")
            .append("svg")
            .attr("height", h + pad.top + pad.bottom)
            .attr("width", w*2 + pad.left + pad.right + pad.middle);
