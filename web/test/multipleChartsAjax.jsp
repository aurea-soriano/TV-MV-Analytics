<%-- 
    Document   : multipleChartsAjax
    Created on : Jan 8, 2016, 5:46:14 PM
    Author     : aurea
--%>
<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="utf-8" />
<title>Correlation Matrix</title>
<style>
.node {
  stroke: #fff;
  stroke-width: 1.5px;
}

.link {
  fill: none;
  stroke: #000;
  stroke-width: 1.5px;
  opacity: 0.4;
  marker-end: url(#end-arrow);
}

</style>
</head>
<body>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8" type="text/javascript"></script>
<script>

//These attributes could be derived from the data
attributes = ["carat","depth","table","price","x","y","z"];
attributeMatrix = [];

attributes.forEach(function (a, x) {
  attributes.forEach(function (b, y) {
    //create an n-by-n matrix based on pairs of attributes
    attributeMatrix.push({a: a, b: b, x: x, y: y})
  })
})

colors = d3.scale.ordinal().range(["#827abf", "#f62150", "#6f89b6", "#f5e0b7", "#5b1e37", "#b9e3c5"]);

d3.csv("https://gist.githubusercontent.com/emeeks/6decab485fd2e02c9f1e/raw/9e4d0d1c427d565aa7e3099120f0eca342d035a2/diamonds.csv", small_scatterplots);

d3.select("body").append("svg").attr("height", 1000).attr("width", 1000)

function small_scatterplots(data) {

  //d3.csv pulls in data as strings so they need to be formatted as numbers
  data.forEach(function (d) {
    attributes.forEach(function (att) {
      d[att] = parseFloat(d[att])
    })
  })

  //create scales dynamically for each attribute's extent

  scale = {};
  attributes.forEach(function (att) {
    scale[att] = d3.scale.linear();
    attExtent = d3.extent(data, function (d) {return d[att]});
    scale[att].domain(attExtent).range([5,95]);
  })

  //bind the matrix array to a grid of g elements
  d3.select("svg")
  .selectAll("g")
  .data(attributeMatrix)
  .enter()
  .append("g")
  .attr("transform", function (d) {return "translate(" + (d.x * 100) + "," + (d.y * 100) + ")" });

  d3.selectAll("g")
  .each(function (matrix, i) {
    //index i is only used for coloring

    //background/border
    d3.select(this).append("rect").style("fill", "white").style("stroke", "black").style("stroke-width", 1)
    .attr("height", 100)
    .attr("width", 100);

    //label
    d3.select(this).append("text")
    .attr("x", 50)
    .style("text-anchor", "middle")
    .attr("y", 15)
    .text(matrix.a + " - " + matrix.b);

    //scatterplot points
    d3.select(this).selectAll("circle")
    .data(data)
    .enter()
    .append("circle")
    .attr("r", 2)
    .style("fill", colors(i))
    .attr("cx", function (d) {return scale[matrix.a](d[matrix.a])})
    .attr("cy", function (d) {return 95 - scale[matrix.b](d[matrix.b])})
  })


}

</script>
</body>
</html>