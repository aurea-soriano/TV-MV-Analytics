<%-- 
    Document   : NormalizedTimeSeriesContent
    Created on : Jun 6, 2016, 7:41:44 PM
    Author     : aurea
--%>

<%@page import="java.awt.Color"%>
<%@page import="color.AureaComplete"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="color.CategoryScale"%>
<%@page import="utils.ColorScale"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<% ArrayList<TimeInterval> listTimeIntervals = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (listTimeIntervals != null) {
        String backgroundColor = request.getParameter("backgroundColor");
        if (backgroundColor == null) {
            backgroundColor = "000000";
        }
        ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");

        ArrayList<Integer> listIdAttributes = new ArrayList<Integer>();

        for (int i = 0; i < listTimeIntervals.size(); i++) {

            if (selectedAttributesSubset.contains(i)) {
                listIdAttributes.add(i);
            }

        }

        ArrayList<JSONArray> matrixValues = new ArrayList<JSONArray>();
        ArrayList<String> nameMatrix = new ArrayList<String>();
        ArrayList<Integer> colorIndices = new ArrayList<Integer>();

        Integer sizeWidth = listTimeIntervals.get(0).getMatrix().getRows() * listTimeIntervals.get(0).getMatrix().getCols() * 15;
        ArrayList<String> listX = listTimeIntervals.get(0).getListLabelsX();
        String formatDate = "";
        if (listX.get(0).contains("day")) {
            formatDate = "yyyy-MM-dd";
        } else {
            if (listX.get(0).contains("month")) {
                formatDate = "yyyy-MM";
            } else {
                formatDate = "yyyy-MM-dd HH:mm:ss";
            }
        }
        for (int attributeItem = 0; attributeItem < listIdAttributes.size(); attributeItem++) {

            JSONArray attributeJSON = new JSONArray();
            Integer idAttribute = listIdAttributes.get(attributeItem);
            ArrayList<String> listAttributeX = listTimeIntervals.get(idAttribute).getListLabelsX();
            ArrayList<String> listAttributeY = listTimeIntervals.get(idAttribute).getListLabelsY();
            for (int i = 0; i < listTimeIntervals.get(idAttribute).getMatrix().getRows(); i++) {
                for (int j = 0; j < listTimeIntervals.get(idAttribute).getMatrix().getCols(); j++) {
                    String part1 = listAttributeY.get(i).replace("day", "-").replace("month", "-").replace(" ", "");
                    String part2 = listAttributeX.get(j).replace("day", "-").replace("month", "-").replace(" ", "");
                    String strTime = part1 + " " + part2;
                    strTime = strTime.replace(" -", "-").trim();
                    Date date = new SimpleDateFormat(formatDate).parse(strTime);
                    JSONObject obj = new JSONObject();
                    obj.put("x", new Long(date.getTime() / 1000));
                    obj.put("y", new Float(listTimeIntervals.get(idAttribute).getMatrix().getValue(i, j)));
                    attributeJSON.add(obj);
                }
            }
            colorIndices.add(listTimeIntervals.get(idAttribute).getIndexColorCluster());
            nameMatrix.add(listTimeIntervals.get(idAttribute).getNameAttribute());
            matrixValues.add(attributeJSON);
        }

%>

<style>
    #behaviorAnalysisDiv {
        position: relative;
        display: inline-block;
        font-family: Arial, Helvetica, sans-serif;
    }
    #chartBehaviorAnalysisDiv {
        display: inline-block;
        margin-left: 40px;
        background-color: #<%=backgroundColor%>;
    }

    #legendBehaviorAnalysisDiv {
        display: inline-block;
        vertical-align: top;
        margin: 0 0 0 10px;
    }
</style>
<div id="behaviorAnalysisDiv">
    <table>
        <tr>

            <td>        <div style="width: 1500px; height: 700px; overflow-y: scroll;" id="chartBehaviorAnalysisDiv"></div>

            </td>
            <td>
                <div id="legendBehaviorAnalysisDiv"></div></td>
        </tr>

    </table></div>

<script>

// instantiate our graph!

    var graph = new Rickshaw.Graph({
        element: document.querySelector("#chartBehaviorAnalysisDiv"),
        width: <%=sizeWidth%>,
        height: 650,
        renderer: 'line',
        stroke: true,
        strokeWidth: 8,
        series: [
    <%      Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");

        for (int i = 0; i < matrixValues.size(); i++) {

            out.write("{ color: d3.rgb(" + colorScaleBackground[colorIndices.get(i)].getRed() + "," + colorScaleBackground[colorIndices.get(i)].getGreen() + ","
                    + colorScaleBackground[colorIndices.get(i)].getBlue() + "), data: "
                    + matrixValues.get(i) + ", name: '" + nameMatrix.get(i) + "'},"
            );

        }
    %>

        ]
    });

    graph.render();

    var hoverDetail = new Rickshaw.Graph.HoverDetail({
        graph: graph
    });

    var legend = new Rickshaw.Graph.Legend({
        graph: graph,
        element: document.getElementById('legendBehaviorAnalysisDiv')

    });

    var shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
        graph: graph,
        legend: legend
    });


    var axes = new Rickshaw.Graph.Axis.Time({
        graph: graph
    });
    axes.render();


</script>
<%}%> 



