<%-- 
    Document   : index
    Created on : Nov 4, 2015, 6:10:41 PM
    Author     : aurea
--%>


<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->




<html>
    <head>
        <meta content='text/html; charset=utf-8' http-equiv='Content-Type'>

        <title>Visual Analytics </title>
        <link rel="shortcut icon" href="favicon.ico" />
        <!--link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,700' rel='stylesheet' type='text/css'-->
        <!--link href='css/opensans_googleapis.css' rel='stylesheet' type='text/css'-->
        <!--link href='https://fonts.googleapis.com/css?family=PT+Serif:400,700,400italic' rel='stylesheet' type='text/css'-->
        <!--link href='css/ptitalic_googleapis.css' rel='stylesheet' type='text/css'-->
        <link href='css/font-awesome.css' rel='stylesheet' type='text/css'>
        <link href='css/bootstrap.min.css' rel='stylesheet' type='text/css'>
        <link href='css/jquery-ui.css' rel='stylesheet' type='text/css'>
        <link href='css/normalize.min.css' rel='stylesheet' type='text/css'>
        <link href='css/scaleColor.css' rel=stylesheet type="text/css" >
        <link href='css/menu.css' rel=stylesheet type="text/css" >
        <link href="css/multiple-select.css" rel="stylesheet" type="text/css">
        <link type="text/css" rel="stylesheet" href="css/RickShaw/graph.css">
        <link type="text/css" rel="stylesheet" href="css/RickShaw/detail.css">
        <link type="text/css" rel="stylesheet" href="css/RickShaw/legend.css">
        <link type="text/css" rel="stylesheet" href="css/switch.css">


        <script src="js/ajax.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/main.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/jquery.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/jquery.form.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/jquery-ui.js" type="text/javascript" charset="utf-8"></script>


        <script src="js/d3.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/d3.layout.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/d3.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/d3.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/d3.v3.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/d3.v3.min.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/clustersGraphVisualization.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/multiple-select.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/RickShaw/rickshaw.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/RickShaw/Rickshaw.Class.js"></script>
        <script src="js/RickShaw/Rickshaw.Compat.ClassList.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Renderer.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Renderer.Area.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Renderer.Line.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Renderer.Bar.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Renderer.ScatterPlot.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.RangeSelector.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.ClickDetail.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.HoverDetail.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Annotate.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Legend.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Axis.Time.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Behavior.Series.Toggle.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Behavior.Series.Order.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Behavior.Series.Highlight.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Smoother.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Unstacker.js"></script>
        <script src="js/RickShaw/Rickshaw.Fixtures.Time.js"></script>
        <script src="js/RickShaw/Rickshaw.Fixtures.Number.js"></script>
        <script src="js/RickShaw/Rickshaw.Fixtures.RandomData.js"></script>
        <script src="js/RickShaw/Rickshaw.Fixtures.Color.js"></script>
        <script src="js/RickShaw/Rickshaw.Color.Palette.js"></script>
        <script src="js/RickShaw/Rickshaw.Graph.Axis.Y.js"></script>
        <script src="js/bundleVisualization.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/packages.js" type="text/javascript" charset="utf-8"></script>

    </head>


    <body>
        <div style="width:1360px;  margin:0 auto; margin:auto;">
            <ul >
                <!--li><a class="inactive" onclick="activeMenu('newConfiguration');"  id="newConfiguration" href="#newConfiguration">New Entry</a></li-->
                <li><a class="active" onclick="activeMenu('initialMenu');"  id="initialMenu" href="index.jsp">Initial</a></li>
                <li><a class="inactive" onclick="activeMenu('homeMenu');"  id="homeMenu" href="#home">Query</a></li>
                <li><a class="inactive" onclick="activeMenu('matrixAttributesMenu');"  id="matrixAttributesMenu"  href="#matrixAttributesMenu">TimeMatrices</a></li>
                <li><a class="inactive" onclick="activeMenu('timeCircularMenu');"  id="timeCircularMenu"  href="#timeCircularMenu">TimeCircular</a></li>
                <li><a class="inactive" onclick="activeMenu('hierarchicalMatrixAttributesMenu');"  id="hierarchicalMatrixAttributesMenu"  href="#hierarchicalMatrixAttributesMenu">HierarchicalTimeMatrices</a></li>
                <li><a class="inactive" onclick="activeMenu('clusterExploration');"  id="clusterExploration" href="#clusterExploration">ClusterExploration</a></li>
                <li><a class="inactive" onclick="activeMenu('subsetAttributesExploration');" id="subsetAttributesExploration" href="#subsetAttributesExploration">SubsetExploration</a></li>
                <li><a class="inactive" onclick="activeMenu('behaviorAnalysis');" id="behaviorAnalysis" href="#behaviorAnalysis">BehaviorAnalysis</a></li>
                <li><a class="inactive" onclick="activeMenu('instanceProjection');" id="instanceProjection" href="#instanceProjection">InstanceProjection</a></li>
                <li><a class="inactive" onclick="activeMenu('evaluationSubsetAttributes');" id="evaluationSubsetAttributes" href="#evaluationSubsetAttributes">Evaluation</a></li>
                <li><a class="inactive" onclick="activeMenu('attributePrediction');" id="attributePrediction" href="#attributePrediction"> Prediction</a></li>
            </ul>
        </div>
        <div id="main_frame" >
            <%@ include file="jsp/InitialView.jsp" %>
        </div>
    </body>
</html>
