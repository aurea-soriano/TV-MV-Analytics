/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function giveColor(value)
{
    if (value === 1)
    {
        return 0;
        // return "#FF0000";

    } else
    {
        return 1;
        //return "#000F89";
    }
}
function replaceAll(str, needle, replacement) {
    return str.split(needle).join(replacement);
}

function createCGVisSpring(nameCluster, width, nodes, links, colorCluster)
{


    var width = width,
            height = width;

    var color = ["#FF0000", colorCluster];
    nodes = replaceAll(nodes, "\'", "\"");
    nodes = JSON.parse(nodes);


    links = replaceAll(links, "\'", "\"");
    links = JSON.parse(links);


    var force = d3.layout.force()
            .charge(-120)
            .linkDistance(100)
            .size([width, height]);

    var svg = d3.select("#" + nameCluster).append("svg")
            .attr("width", width)
            .attr("height", height);


    //d3.json("js/miserables.json", function (error, graph) {
    // if (error)
    //    throw error;

    force
            .nodes(nodes)
            .links(links)
            .start();

    var link = svg.selectAll(".link")
            .data(links)
            .enter().append("line")
            .attr("class", "link")
            .style("stroke-width", "2px").style("stroke", "#ccc");



    var node = svg.selectAll(".node")
            .data(nodes)
            .enter().append("circle")
            .attr("class", "node")
            .attr("r", 4).attr("stroke-width", 1).attr("stroke", "black")
            .style("fill", function (d) {
                return color[giveColor(d.group)];
            })
            .call(force.drag);


    var texts = svg.selectAll("text.label")
            .data(nodes)
            .enter().append("text")
            .attr("class", "label")
            .attr("fill", "black")
            .text(function (d) {
                return d.name;
            });



    force.on("tick", function () {
        link.attr("x1", function (d) {
            return d.source.x;
        })
                .attr("y1", function (d) {
                    return d.source.y;
                })
                .attr("x2", function (d) {
                    return d.target.x;
                })
                .attr("y2", function (d) {
                    return d.target.y;
                });
        node.attr("cx", function (d) {
            return d.x;
        })
                .attr("cy", function (d) {
                    return d.y;
                }).on("dblclick", function (d) {
            addRemoveAttributeSubsetSelection2(d.id);
        });
        texts.attr("transform", function (d) {
            return "translate(" + (d.x + 7.0) + "," + (d.y + 4.0) + ")";
        });
    });
    //});

}

function createCGVisSpringSubSet(nameCluster, width, nodes, links, colorCluster)
{


    var width = width,
            height = width;

    var color = ["#FF0000", colorCluster];
    nodes = replaceAll(nodes, "\'", "\"");
    nodes = JSON.parse(nodes);


    links = replaceAll(links, "\'", "\"");
    links = JSON.parse(links);


    var force = d3.layout.force()
            .charge(-120)
            .linkDistance(100)
            .size([width, height]);

    var svg = d3.select("#" + nameCluster).append("svg")
            .attr("width", width)
            .attr("height", height);


    //d3.json("js/miserables.json", function (error, graph) {
    // if (error)
    //    throw error;

    force
            .nodes(nodes)
            .links(links)
            .start();

    var link = svg.selectAll(".link")
            .data(links)
            .enter().append("line")
            .attr("class", "link")
            .style("stroke-width", "2px").style("stroke", "#ccc");



    var node = svg.selectAll(".node")
            .data(nodes)
            .enter().append("circle")
            .attr("class", "node")
            .attr("r", 4).attr("stroke-width", 1).attr("stroke", "black")
            .style("fill", function (d) {
                return color[giveColor(d.group)];
            })
            .call(force.drag);


    var texts = svg.selectAll("text.label")
            .data(nodes)
            .enter().append("text")
            .attr("class", "label")
            .attr("fill", "black")
            .text(function (d) {
                return d.name;
            });



    force.on("tick", function () {
        link.attr("x1", function (d) {
            return d.source.x;
        })
                .attr("y1", function (d) {
                    return d.source.y;
                })
                .attr("x2", function (d) {
                    return d.target.x;
                })
                .attr("y2", function (d) {
                    return d.target.y;
                });
        node.attr("cx", function (d) {
            return d.x;
        })
                .attr("cy", function (d) {
                    return d.y;
                }).on("dblclick", function (d) {
            addRemoveAttributeSubsetSelection5(d.id);
        });
        texts.attr("transform", function (d) {
            return "translate(" + (d.x + 7.0) + "," + (d.y + 4.0) + ")";
        });
    });
    //});

}


function createCGVisGeneralProjection(nameContent, width, height, projections)
{
//alert(projections);
    //Make an SVG Container


    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            })
            .attr("r", 6)
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 1).attr("stroke", "black")
            .attr('fill-opacity', 0.8).on("dblclick", function (d) {
        addRemoveAttributeSubsetSelection2(d.id);
    }).append("svg:title")
            .text(function (d) {
                return d.name;
            });




}
function minmax(valueIn, baseMin, baseMax, limitMin, limitMax) {
    var den = (baseMax - baseMin);
    if (den === 0.0) {
        den = 0.000000000001;
    }

    return ((limitMax - limitMin) * (valueIn - baseMin) / den) + limitMin;
}


function createCGVisHierarchicalProjection(nameContent, width, height, projections, maxGroup)
{
//alert(projections);
    //Make an SVG Container


    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            })
            .attr("r", function (d) {
                return minmax(d.num, 1, maxGroup, 8, 80)
            })
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 1).attr("stroke", "black")
            .attr('fill-opacity', 1).on("dblclick", function (d) {
        if (d.num === 1)
        {
            addRemoveAttributeSubsetSelection2(d.id);
        } else
        {
            var message = replaceAll(d.name, "#", "\n #");
            alert(message);
        }
    }).append("svg:title")
            .text(function (d) {
                var message = replaceAll(d.name, "#", "\n #");
                return message;
            });




}


function createHierarchicalInstanceProjection(nameContent, width, height, projections, maxGroup)
{
//alert(projections);
    //Make an SVG Container


    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            })
            .attr("r", function (d) {
                return minmax(d.num, 1, maxGroup, 5, 22);
            })
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 1).attr("stroke", "black")
            .attr('fill-opacity', 1).on("dblclick", function (d) {
        if (d.num === 1)
        {
            addRemoveAttributeSubsetSelection2(d.id);
        } else
        {
            var message = replaceAll(d.name, "#", "\n #");
            alert(message);
        }
    }).append("svg:title")
            .text(function (d) {
                var message = replaceAll(d.name + " - " + d.date, "#", "\n #");
                return message;
            });




}



function createCGVisGeneralProjectionSubSet(nameContent, width, height, projections)
{
//alert(projections);
    //Make an SVG Container
    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            })
            .attr("r", 4)
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 1).attr("stroke", "black")
            .attr('fill-opacity', 1).on("dblclick", function (d) {
        addRemoveAttributeSubsetSelection5(d.id);
    }).append("svg:title")
            .text(function (d) {
                return d.name;
            });




}

function focusProjectionCircle(id) {
    var element = d3.select('#circle' + id);
    if (element !== null && !element.empty() && element !== "") {
        document.getElementById('idPreviousCircleAttribute').value = id;
        document.getElementById('borderColorPreviousCircleAttribute').value = element.attr("stroke");
        element.style('stroke', 'red').style("stroke-width", 2);

        var borderColorPreviousAttribute = document.getElementById('matrix' + id).style.borderColor;
        document.getElementById('matrix' + id).style.borderColor = 'red';
        document.getElementById('idPreviousAttribute').value = id;
        document.getElementById('borderColorPreviousAttribute').value = borderColorPreviousAttribute;
    }

}

function repaintPreviousBorderColor()
{

    var id = document.getElementById('idPreviousAttribute').value;
    var colorBorder = document.getElementById('borderColorPreviousAttribute').value;
    if (id !== null && colorBorder !== null && id !== "" && colorBorder !== "") {
        document.getElementById('matrix' + id).style.borderColor = colorBorder;
        document.getElementById('idPreviousAttribute').value = "";
        document.getElementById('borderColorPreviousAttribute').value = "";
    }

    var idCircle = document.getElementById('idPreviousCircleAttribute').value;
    var colorBorderCircle = document.getElementById('borderColorPreviousCircleAttribute').value;
    if (idCircle !== null && colorBorderCircle !== null && idCircle !== "" && colorBorderCircle !== "") {
        var element = d3.select('#circle' + idCircle);
        element.style('stroke', colorBorderCircle).style("stroke-width", 2);
        document.getElementById('idPreviousCircleAttribute').value = "";
        document.getElementById('borderColorPreviousCircleAttribute').value = "";
    }
}


function repaintPreviousHierarchicalBorderColor()
{

    var id = document.getElementById('idPreviousAttribute').value;
    var colorBorder = document.getElementById('borderColorPreviousAttribute').value;
    if (id !== null && colorBorder !== null && id !== "" && colorBorder !== "") {
        var matrixMember = document.getElementById('matrixMemberMember' + id);
        if (matrixMember != null) {
            document.getElementById('matrixMemberMember' + id).style.borderColor = colorBorder;
        }
        var matrixMemberMedoid = document.getElementById('matrixMemberMedoid' + id);
        if (matrixMemberMedoid != null) {
            document.getElementById('matrixMemberMedoid' + id).style.borderColor = colorBorder;
        }

        document.getElementById('idPreviousAttribute').value = "";
        document.getElementById('borderColorPreviousAttribute').value = "";
    }

    var idCircle = document.getElementById('idPreviousCircleAttribute').value;
    var colorBorderCircle = document.getElementById('borderColorPreviousCircleAttribute').value;
    if (idCircle !== null && colorBorderCircle !== null && idCircle !== "" && colorBorderCircle !== "") {
        var element = d3.select('#circle' + idCircle);
        element.style('stroke', colorBorderCircle).style("stroke-width", 2);
        document.getElementById('idPreviousCircleAttribute').value = "";
        document.getElementById('borderColorPreviousCircleAttribute').value = "";
    }
}

function createCGVisGeneralProjectionMatrices(nameContent, width, height, projections, maxGroup)
{

//alert(projections);
    //Make an SVG Container


    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    var circle = svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            }).attr("id", function (d) {
        return "circle" + d.id;
    })
            .attr("r", function (d) {
                return minmax(d.num, 1, maxGroup, 8, 58)
            })
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 2).attr("stroke", "black")
            //function (d) {  return "#" + d.bordercolor;    })

            .attr('fill-opacity', 1).on("dblclick", function (d) {
        if (d.num === 1)
        {
            $('#selectCluster' + d.id).focus();
            var borderColorPreviousAttribute = document.getElementById('matrix' + d.id).style.borderColor;
            document.getElementById('matrix' + d.id).style.borderColor = 'red';
            document.getElementById('idPreviousAttribute').value = d.id;
            document.getElementById('borderColorPreviousAttribute').value = borderColorPreviousAttribute;
            document.getElementById('idPreviousCircleAttribute').value = d.id;
            document.getElementById('borderColorPreviousCircleAttribute').value = d3.select(this).style("stroke");
            d3.select(this).style("stroke", 'red');
            d3.select(this).style("stroke-width", 2);

        } else
        {
            var message = replaceAll(d.name, "#", "\n #");
            alert(message);
        }
    }).append("svg:title")
            .text(function (d) {
                var message = replaceAll(d.name, "#", "\n #");
                return message;
            });
}

function createHierarchicalProjectionHierachicalMatrices(nameContent, width, height, projections, maxGroup, listMembers, listMedoids)
{

    var arrayMembers = JSON.parse(listMembers)
    var arrayMedoids = JSON.parse(listMedoids)
    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    var circle = svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            }).attr("id", function (d) {
        return "circle" + d.id;
    })
            .attr("r", function (d) {
                return minmax(d.num, 1, maxGroup, 8, 58)
            })
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 2).attr("stroke", function (d) {


         if (contains(arrayMedoids, d.id) === true) {
                    return "black";
                } else {
                    if (contains(arrayMembers, d.id) === true) {
                        return "dimGray";
                    } else {
                        return "white";
                    }
                }
    })
            //function (d) {  return "#" + d.bordercolor;    })
            .attr('fill-opacity', function (d) {


                if (contains(arrayMedoids, d.id) === true) {
                    return 1;
                } else {
                    if (contains(arrayMembers, d.id) === true) {
                        return 0.7;
                    } else {
                        return 0.2;
                    }
                }
            }).on("dblclick", function (d) {
        if (d.num === 1)
        {

            var matrixMember = document.getElementById('matrixMemberMember' + d.id);

            if (matrixMember !== null) {

                var borderColorPreviousAttribute = document.getElementById('matrixMemberMember' + d.id).style.borderColor;
                var matrixMemberMedoid = document.getElementById('matrixMemberMedoid' + d.id);
                if (matrixMemberMedoid !== null) {

                    document.getElementById('matrixMemberMedoid' + d.id).style.borderColor = 'red';
                }
                document.getElementById('matrixMemberMember' + d.id).style.borderColor = 'red';
                document.getElementById('idPreviousAttribute').value = d.id;
                document.getElementById('borderColorPreviousAttribute').value = borderColorPreviousAttribute;
                document.getElementById('idPreviousCircleAttribute').value = d.id;
                document.getElementById('borderColorPreviousCircleAttribute').value = d3.select(this).style("stroke");
                d3.select(this).style("stroke", 'red');
                d3.select(this).style("stroke-width", 2);
            }


        } else
        {
            var message = replaceAll(d.name, "#", "\n #");
            alert(message);
        }
    })
            .append("svg:title")
            .text(function (d) {
                var message = replaceAll(d.name, "#", "\n #");
                return message;
            });
}
function contains(a, obj) {
    var i = a.length;
    while (i--) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
}

function createInstanceProjection(nameContent, width, height, projections)
{
//alert(projections);
    //Make an SVG Container


    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            })
            .attr("r", 5)
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 1).attr("stroke", "black")
            .append("svg:title")
            .text(function (d) {
                return d.name + " - " + d.date;
            });




}


function createHierarchicalProjectionMatricesByCategory(nameContent, width, height, projections, maxGroup)
{

//alert(projections);
    //Make an SVG Container


    var svgContainer = d3.select("#" + nameContent).append("svg")
            .attr("width", width)
            .attr("height", height);
    var dataset = replaceAll(projections, "\'", "\"");
    dataset = JSON.parse(dataset);



    var circle = svgContainer.selectAll("circle")
            .data(dataset)
            .enter()
            .append("circle").attr("cx", function (d) {
        return d.x;
    })
            .attr("cy", function (d) {
                return d.y;
            }).attr("id", function (d) {
        return "circle" + d.id;
    })
            .attr("r", function (d) {
                return minmax(d.num, 1, maxGroup, 8, 58)
            })
            .attr("fill", function (d) {
                return "#" + d.color;
            }).attr("stroke-width", 2).attr("stroke", "black")
            //function (d) {  return "#" + d.bordercolor;    })

            .attr('fill-opacity', 1).on("dblclick", function (d) {
        if (d.num === 1)
        {
            $('#selectCluster' + d.id).focus();
            var borderColorPreviousAttribute = document.getElementById('matrix' + d.id).style.borderColor;
            document.getElementById('matrix' + d.id).style.borderColor = 'red';
            document.getElementById('idPreviousAttribute').value = d.id;
            document.getElementById('borderColorPreviousAttribute').value = borderColorPreviousAttribute;
            document.getElementById('idPreviousCircleAttribute').value = d.id;
            document.getElementById('borderColorPreviousCircleAttribute').value = d3.select(this).style("stroke");
            d3.select(this).style("stroke", 'red');
            d3.select(this).style("stroke-width", 2);

        } else
        {
            var message = replaceAll(d.name, "#", "\n #");
            alert(message);
        }
    }).append("svg:title")
            .text(function (d) {
                var message = replaceAll(d.name, "#", "\n #");
                return message;
            });
}
