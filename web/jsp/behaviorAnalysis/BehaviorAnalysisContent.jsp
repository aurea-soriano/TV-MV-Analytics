<%-- 
    Document   : behaviorAnalysisContent
    Created on : Jun 6, 2016, 7:41:44 PM
    Author     : aurea
--%>

<%@page import="utils.Operations"%>
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
        String listAttributesArray = request.getParameter("listAttributes");
        String backgroundColor = request.getParameter("backgroundColor");
        Color[] colorScaleCell = (Color[]) session.getAttribute("colorScaleCell");
        String aggregationFunction = (String) session.getAttribute("aggregationFunction");
        String valueUnitTimeInterval = (String) session.getAttribute("valueUnitTimeInterval");
        String unitTimeInterval = (String) session.getAttribute("unitTimeInterval");

        String[] listAttribute = listAttributesArray.split(",");
        ArrayList<JSONArray> matrixValues = new ArrayList<JSONArray>();
        ArrayList<String> nameMatrix = new ArrayList<String>();
        ArrayList<Integer> colorIndices = new ArrayList<Integer>();

        Integer sizeWidth = listTimeIntervals.get(0).getMatrix().getRows() * listTimeIntervals.get(0).getMatrix().getCols() * 10;
        ArrayList<String> listX = listTimeIntervals.get(0).getListLabelsX();
        ArrayList<String> listY = listTimeIntervals.get(0).getListLabelsY();
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
        for (int attributeItem = 0; attributeItem < listAttribute.length; attributeItem++) {

            JSONArray attributeJSON = new JSONArray();
            Integer idAttribute = Integer.valueOf(listAttribute[attributeItem]);
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

            <td>        <div style="width: <%=(sizeWidth+100)%>px; height: 700px; overflow-y: scroll;" id="chartBehaviorAnalysisDiv"></div>

            </td>
            <td>
                <div id="legendBehaviorAnalysisDiv"></div></td>
        </tr>
        <tr style="height: 10px;">

        </tr>
        <%if (listTimeIntervals.size() > 0) {%>
        <tr>
            <td colspan="2">
                <table style="width: <%=(sizeWidth+180)%>px;">
                  
                    <%
                        for (int attributeItem = 0; attributeItem < listAttribute.length; attributeItem++) {
                            //for (int index = 0; index < listTimeIntervals.size(); index++) {
                            int index =  Integer.valueOf(listAttribute[attributeItem]);
                    %>    
                    <tr>
                        <td style="width: 115px;"></td>
                        
                        <%    for (int row = 0; row < listTimeIntervals.get(0).getMatrix().getRows(); row++) {
                                for (int col = 0; col < listTimeIntervals.get(0).getMatrix().getCols(); col++) {

                                    Double value = listTimeIntervals.get(index).getMatrix().getValue(row, col);
                                    Double origValue = listTimeIntervals.get(index).getMatrix().getOriginalValue(row, col);
                                    boolean flag = listTimeIntervals.get(index).getMatrix().getFlag(row, col);
                                    Double minValue = listTimeIntervals.get(index).getMatrix().getMinValue();
                                    Double maxValue = listTimeIntervals.get(index).getMatrix().getMaxValue();

                                    int positionColorCell = (int) Math.round(value);
                                    Double originalValue = Double.NaN;
                                    if (origValue != Double.NEGATIVE_INFINITY && value != Double.NEGATIVE_INFINITY) {
                                        originalValue = origValue;
                                    }

                                    boolean interpolatedFlag = (boolean) flag;
                                    Color colorCell = Color.WHITE;
                                    if (positionColorCell >= 0) {
                                        colorCell = colorScaleCell[255 - positionColorCell];
                                    } else {
                                        colorCell = Color.gray;
                                    }

                                    if (originalValue.isNaN() && colorCell != Color.gray) {

                                        Double valueInterpolated = Operations.minmax((positionColorCell) * 1.0, 0.0, 255.0, minValue, maxValue);
                                        originalValue = (Math.round(valueInterpolated * 100.0)) / 100.0;
                                    }
                                    int red = colorCell.getRed();
                                    int green = colorCell.getGreen();
                                    int blue = colorCell.getBlue();
                        %>
                        <td title="<%out.print(listTimeIntervals.get(index).getNameAttribute() + "\n" + listTimeIntervals.get(index).getValueSource() + "\n" + listY.get(row) + "\n" + listX.get(col) + " \n" + aggregationFunction + " value: " + originalValue + " in "
                                    + valueUnitTimeInterval + " " + unitTimeInterval + "(s)");%>"   
                            style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                            width: 22px; height: 22px;
                            color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                            <%if (interpolatedFlag == true) {
                            %>
                            border: 1px solid red;
                            <%}%>" 
                            width="22px" height="22px"
                            ondblclick="loadNews('<%=listY.get(row)%>', '<%=listX.get(col)%>', '<%=listTimeIntervals.get(index).getNameAttribute()%>', '<%=listTimeIntervals.get(index).getValueSource()%>');">

                        </td>
                        <%
                            }}%>
                            
                    </tr>
                    <%
                        }%>
                </table>
            </td>
        </tr>
        <%}%>

    </table></div>

<script>

    // instantiate our graph!

    var graph = new Rickshaw.Graph({
        element: document.querySelector("#chartBehaviorAnalysisDiv"),
        width: <%=(sizeWidth+75)%>,
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



