<%-- 
    Document   : NormalizedTimeSeries
    Created on : Jun 6, 2016, 5:53:30 PM
    Author     : aurea
--%>

<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<TimeInterval> listTimeIntervalAttributes = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (listTimeIntervalAttributes != null) {


%>
<html>
    <head>
        <meta content='text/html; charset=utf-8' http-equiv='Content-Type'>

        <title>Visual Analytics </title>
        <link rel="shortcut icon" href="favicon.ico" />


        <link href='../../css/font-awesome.css' rel='stylesheet' type='text/css'>
        <link href='../../css/bootstrap.min.css' rel='stylesheet' type='text/css'>
        <link href='../../css/jquery-ui.css' rel='stylesheet' type='text/css'>
        <link href='../../css/normalize.min.css' rel='stylesheet' type='text/css'>
        <link href='../../css/scaleColor.css' rel=stylesheet type="text/css" >
        <link href='../../css/menu.css' rel=stylesheet type="text/css" >
        <link href="../../css/multiple-select.css" rel="stylesheet" type="text/css">
        <link type="text/css" rel="stylesheet" href="../../css/RickShaw/graph.css">
        <link type="text/css" rel="stylesheet" href="../../css/RickShaw/detail.css">
        <link type="text/css" rel="stylesheet" href="../../css/RickShaw/legend.css">

        <script src="../../js/ajax.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/main.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery.form.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/d3.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/d3.v3.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/d3.v3.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/clustersGraphVisualization.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/multiple-select.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/RickShaw/rickshaw.js" type="text/javascript" charset="utf-8"></script>
        <script src="../../js/RickShaw/Rickshaw.Class.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Compat.ClassList.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Renderer.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Renderer.Area.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Renderer.Line.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Renderer.Bar.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Renderer.ScatterPlot.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.RangeSelector.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.ClickDetail.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.HoverDetail.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Annotate.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Legend.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Axis.Time.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Behavior.Series.Toggle.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Behavior.Series.Order.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Behavior.Series.Highlight.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Smoother.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Unstacker.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Fixtures.Time.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Fixtures.Number.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Fixtures.RandomData.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Fixtures.Color.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Color.Palette.js"></script>
        <script src="../../js/RickShaw/Rickshaw.Graph.Axis.Y.js"></script>
    </head>
    <body>
        <br>
        <div class="well" style="width:350px; height: 80px;   margin:0 auto; margin:auto; text-align: center;">
            <table>
                <tr><td style="width:60%; text-align: right;" ><b>Background color:</b></td><td style="width:40%">
                        <select style="width:100%;" name="listBackgroundColor" id="listBackgroundColor"  >
                            <option value="<%="000000"%>" >Black</option>
                            <option value="<%="F0FFFF"%>" >Light Blue</option>
                            <option value="<%="FFF0FF"%>" >Light Red</option>
                            <option value="<%="FFFFF0"%>" >Light Yellow</option>
                            <option value="<%="CE2029"%>" >Red</option>
                            <option value="<%="FFFFFF"%>" >White</option>
                            <option value="<%="FFFF0F"%>" >Yellow</option>
                        </select>

                    </td>
                </tr>

            </table>

        </div>

        <div class="col-sm-12" style="margin:0 auto; margin:auto; text-align: center;">
            <button  id="normalizedTimeSeriesButton" name="normalizedTimeSeriesButton"  type="button"  onclick="normalizedTimeSeries();"><b>Update</b></button>
        </div>

        <br>
        <br>

        <div id="normalizedTimeSeriesContent" style="text-align: center;">

            <%@ include file="NormalizedTimeSeriesContent.jsp" %>
        </div>

    </body></html>


<%
} else {
%>

<br>
<br>
<table style="text-align: center; margin:0 auto; margin:auto;">
    <tr>
        <td>


            <div class="col-sm-12">

                Error with the query.
            </div>
        </td>
    </tr>
</table>
<%
    }%>