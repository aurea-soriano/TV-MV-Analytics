/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function replaceAll(str, needle, replacement) {
    return str.split(needle).join(replacement);
}


function createTimeMatrixBundleVisualization(nameContent, width, height, timeCircularJSon)
{



    var w = width,
            h = height,
            rx = w / 2,
            ry = h / 2,
            m0,
            rotate = 0;


    var splines = [];
    var ryy = ry - 10;
    var cluster = d3.layout.cluster()
            .size([360, ryy]);//ry - 120]);
    var bundle = d3.layout.bundle();
    var line = d3.svg.line.radial()
            .interpolate("bundle")
            .tension(0.9)
            .radius(function (d) {
                return d.y;
            })
            .angle(function (d) {
                return d.x / 180 * Math.PI;
            });
    //time circle

    var innerRadius = width / 2;
    var outerRadius = width / 2.1;


    var arc = d3.svg.arc()
            // .innerRadius(innerRadius)
            //.outerRadius(outerRadius);
            .outerRadius(outerRadius).innerRadius(innerRadius);
    var pie = d3.layout.pie().startAngle(0).endAngle(2 * Math.PI);
    pie.sort(null);




    var splines = [];
    var ryy = ry - 10;
    var cluster = d3.layout.cluster()
            .size([360, ryy]);//ry - 120]);
    var bundle = d3.layout.bundle();
    var line = d3.svg.line.radial()
            .interpolate("bundle")
            .tension(0.9)
            .radius(function (d) {
                return d.y;
            })
            .angle(function (d) {
                return d.x / 180 * Math.PI;
            });


// Chrome 15 bug: <http://code.google.com/p/chromium/issues/detail?id=98951>
    var div = d3.select("#" + nameContent).insert("div", "h2")
            .style("width", w + "px")
            .style("height", h + "px")
            // .style("position", "absolute")
            .style("-webkit-backface-visibility", "hidden").style("background-color", "white");
    var svg = div.append("svg:svg")
            .attr("width", w)
            .attr("height", h)
            .append("svg:g")
            .attr("transform", "translate(" + rx + "," + ry + ")");

    svg.append("svg:path")
            .attr("class", "arc")
            .attr("d", d3.svg.arc().outerRadius(ry - 120).innerRadius(0).startAngle(0).endAngle(2 * Math.PI));
    // Define the div for the tooltip
    var tootltip = d3.select("#" + nameContent).append("div")
            .attr("class", "tooltip")
            .style("opacity", 0);

    //d3.json("tempData/test.json", function (classes) {

    var dataset = replaceAll(timeCircularJSon, "\'", "\"");
    var classes = JSON.parse(dataset);

    var nodes = cluster.nodes(packages.root(classes)), //(packages.root(classes)),
            links = packages.imports(nodes),
            splines = bundle(links),
            sizes = packages.sizes(nodes),
            colors = packages.colors(nodes),
            names = packages.names(nodes),
            origvalues = packages.origvalues(nodes);


    var arcs = svg.selectAll("arc")
            .data(pie(sizes))
            .enter()
            .append("g")
            .attr("class", "arc")
            .attr("d", d3.svg.arc().outerRadius(ry - 120).innerRadius(0).startAngle(0).endAngle(2 * Math.PI));

    arcs.append("path")
            .attr("fill", function (d, i) {
                return "#" + colors[i];
            })
            .attr("d", arc).on("mouseover", function (d, i) {
        tootltip.transition()
                .duration(200)
                .style("opacity", .9);
        tootltip.html(names[i] + " val: " + origvalues[i])
                .style("left", (d3.event.pageX - 120) + "px")
                .style("top", (d3.event.pageY - 30) + "px");
    })
            .on("mouseout",  function (d, i) {
                tootltip.transition()
                        .duration(200)
                        .style("opacity", 0);
            });


    var path = svg.selectAll("path.link")
            .data(links)
            .enter().append("svg:path")
            .attr("class", function (d) {
                return "link source-" + d.source.key + " target-" + d.target.key;
            })
            .attr("d", function (d, i) {
                return line(splines[i]);
            });
    var node = svg.selectAll("g.node")
            .data(nodes.filter(function (n) {
                return !n.children;
            }))
            .enter().append("svg:g")
            .attr("class", "node")
            .attr("id", function (d) {
                return "node-" + d.key;
            })
            .attr("transform", function (d) {
                return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")";
            })

            .append("svg:text")
            .attr("dx", function (d) {
                return d.x < 180 ? 8 : -8;
            })
            .attr("dy", ".31em")
            .attr("text-anchor", function (d) {
                return d.x < 180 ? "start" : "end";
            })
            .attr("transform", function (d) {
                return d.x < 180 ? null : "rotate(180)";
            })
             .text(function(d) { return "|"; })
            .on("mouseover", mouseovered)
            .on("mouseout", mouseouted);

    /*.text(function (d) {
     return d.key;
     }).style('fill', function (d) {
     return "#" + d.color;
     })
     .on("mouseover", function (d, i) {
     tootltip.transition()
     .duration(200)
     .style("opacity", .9);
     tootltip.html(d.key)
     .style("left", (d3.event.pageX - 180) + "px")
     .style("top", (d3.event.pageY - 50) + "px");
     })
     .on("mouseout", function (d, i) {
     tootltip.transition()
     .duration(200)
     .style("opacity", 0);
     });*/




    // });
  function mouseovered(d) {
  node
      .each(function(n) { n.target = n.source = false; });

  path
      .classed("link--target", function(l) { if (l.target === d) return l.source.source = true; })
      .classed("link--source", function(l) { if (l.source === d) return l.target.target = true; })
    .filter(function(l) { return l.target === d || l.source === d; })
      .raise();

  node
      .classed("node--target", function(n) { return n.target; })
      .classed("node--source", function(n) { return n.source; });
}

function mouseouted(d) {
  path
      .classed("link--target", false)
      .classed("link--source", false);

  node
      .classed("node--target", false)
      .classed("node--source", false);
}

    function cross(a, b) {
        return a[0] * b[1] - a[1] * b[0];
    }

    function dot(a, b) {
        return a[0] * b[0] + a[1] * b[1];
    }

}
/*
 // Returns a flattened hierarchy containing all leaf nodes under the root.
 function classes(root) {
 var classes = [];
 
 function recurse(name, node) {
 if (node.children)
 node.children.forEach(function (child) {
 recurse(node.name, child);
 });
 else
 classes.push({packageName: name, className: node.name, value: node.size});
 }
 
 recurse(null, root);
 return {children: classes};
 }*/
