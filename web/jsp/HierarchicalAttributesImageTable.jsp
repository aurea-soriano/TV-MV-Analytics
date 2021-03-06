<%-- 
    Document   : attributesImageTable
    Created on : Jan 11, 2016, 4:07:09 PM
    Author     : aurea
--%>


<%@page import="trees.clusteringtree.ClusteringTree"%>
<%@page import="trees.clusteringtree.ClusteringNode"%>
<%@page import="color.BTC"%>
<%@page import="projection.FastmapProjection"%>
<%@page import="projection.IDMAPProjection"%>
<%@page import="projection.ForceSchemeProjection2D"%>
<%@page import="projection.ProjClusProjection"%>
<%@page import="trees.kdtree.KDTree"%>
<%@page import="trees.kdtree.KDData"%>
<%@page import="trees.kdtree.Point2D"%>
<%@page import="utils.Operations"%>
<%@page import="projection.LSPProjection2D.ControlPointsType"%>
<%@page import="projection.LSPProjection2D"%>
<%@page import="utils.Util"%>
<%@page import="matrix.pointsmatrix.DenseMatrix"%>
<%@page import="color.AureaComplete"%>
<%@page import="color.HeatedObject"%>
<%@page import="utils.ColorScale"%>
<%@page import="clustering.SilhouetteCoefficient"%>
<%@page import="clustering.BKmedoids"%>
<%@page import="clustering.BKmeans"%>
<%@page import="clustering.Kmedoids"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%@page import="clustering.Kmeans"%>
<%@page import="clustering.Xmeans"%>
<%@page import="clustering.Clustering"%>
<%@page import="dataMaker.Matrix"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>



<%
    ArrayList<TimeInterval> listTimeIntervals = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    ClusteringTree clusteringTree = (ClusteringTree) session.getAttribute("clusteringTree");
    ClusteringNode currentClusteringNode = (ClusteringNode) session.getAttribute("currentClusteringNode");
    String aggregationFunction = (String) session.getAttribute("aggregationFunction");
    String valueUnitTimeInterval = (String) session.getAttribute("valueUnitTimeInterval");
    String unitTimeInterval = (String) session.getAttribute("unitTimeInterval");
    String explorationOption = request.getParameter("explorationOption");

    if (listTimeIntervals != null) {

        ArrayList<TimeInterval> currentMedoidTimeMatrices = new ArrayList<TimeInterval>();
        ArrayList<TimeInterval> currentMemberTimeMatrices = new ArrayList<TimeInterval>();

        if (clusteringTree == null) {
            currentClusteringNode = clusteringTree.getRoot();
            session.setAttribute("currentClusteringNode", currentClusteringNode);
        } else {
            if (explorationOption != null) {
                if (explorationOption.equals("parent")) {
                    ClusteringNode previousClusteringNode = currentClusteringNode;
                    currentClusteringNode = currentClusteringNode.getParent();
                    if (currentClusteringNode == null) {
                        currentClusteringNode = previousClusteringNode;
                    }
                } else {
                    if (explorationOption.equals("root")) {
                        ClusteringNode previousClusteringNode = currentClusteringNode;
                        currentClusteringNode = clusteringTree.getRoot();
                        if (currentClusteringNode == null) {
                            currentClusteringNode = previousClusteringNode;
                        }
                    } else {

                        currentClusteringNode = currentClusteringNode.getListChildNodes().get(Integer.valueOf(explorationOption));

                    }
                }
                session.setAttribute("currentClusteringNode", currentClusteringNode);
            }
        }

        if (currentClusteringNode == null) {
            currentClusteringNode = clusteringTree.getRoot();
            session.setAttribute("currentClusteringNode", currentClusteringNode);
        }

        ArrayList<Integer> listMedoids = new ArrayList<Integer>();
        String arrayMedoids = "[";
         String arrayMembers = "[";
        ArrayList<Integer> listMembers = new ArrayList<Integer>();
        listMedoids = currentClusteringNode.getListMedoids();
        listMembers = currentClusteringNode.getListMembers();

        for (int i = 0; i < listMedoids.size(); i++) {
            currentMedoidTimeMatrices.add(listTimeIntervals.get(listMedoids.get(i)));
            arrayMedoids += listMedoids.get(i) + ",";
        }
        arrayMedoids = arrayMedoids.substring(0, arrayMedoids.length() - 1);
        arrayMedoids += "]";
        for (int i = 0; i < listMembers.size(); i++) {
            currentMemberTimeMatrices.add(listTimeIntervals.get(listMembers.get(i)));
            arrayMembers += listMembers.get(i) + ",";
        }
 arrayMembers = arrayMembers.substring(0, arrayMembers.length() - 1);
        arrayMembers += "]";
        if (currentMedoidTimeMatrices.size() > 0 && currentMemberTimeMatrices.size() > 0) {
            int numMedoidCols = 5;

            if (numMedoidCols > currentMedoidTimeMatrices.size()) {
                numMedoidCols = currentMedoidTimeMatrices.size();
            }

            int numMedoidRows = (int) Math.ceil(currentMedoidTimeMatrices.size() * 1.0 / numMedoidCols);

            Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
            Color[] colorScaleCell = (Color[]) session.getAttribute("colorScaleCell");
            int sizeMedoidCellWidth = (int) Math.ceil(300 / currentMedoidTimeMatrices.get(0).getMatrix().getCols()) + 3;
            int sizeMedoidCellHeight = (int) Math.ceil(270 / currentMedoidTimeMatrices.get(0).getMatrix().getRows()) + 3;

            if (sizeMedoidCellWidth < 5) {
                sizeMedoidCellWidth = 5;
            }
            if (sizeMedoidCellHeight < 5) {
                sizeMedoidCellHeight = 5;
            }

            int widthMedoidTable = sizeMedoidCellWidth * currentMedoidTimeMatrices.get(0).getMatrix().getCols() + 10;
            if (widthMedoidTable < 300) {
                widthMedoidTable = 300;
            }

            Color[] colorScaleBorder = (new BTC()).getColorScale();

            //Projection
            AbstractMatrix projectedMatrix = (AbstractMatrix) session.getAttribute("projectedMatrix");
            String datasetProjection = (String) session.getAttribute("datasetProjection");
            Integer numberMaxGroup = (Integer) session.getAttribute("numberMaxGroup");
            Integer hierarchicalLevelRange = 1;
            session.setAttribute("arrayMedoids", arrayMedoids);
            session.setAttribute("arrayMembers", arrayMembers);
%>

<div id="previousAttributeClick">
    <input hidden="hidden" id="previousMedoidIds" value="" >
    <input  hidden="hidden"id="previousMedoidColors" value="" >
    <input  hidden="hidden" id="previousMemberIds" value="" >
    <input  hidden="hidden" id="previousMemberColors" value="" >
    <input hidden="hidden" id="idPreviousAttribute" value="" >
    <input  hidden="hidden"id="borderColorPreviousAttribute" value="" >
    <input  hidden="hidden" id="idPreviousCircleAttribute" value="" >
    <input  hidden="hidden" id="borderColorPreviousCircleAttribute" value="" >
</div>
<div id="HierarchicalAttributeMatricesContent" onclick="repaintPreviousHierarchicalBorderColor();repaintPreviousBorderHierarchicalMembers();" >
    <table style="text-align: center; margin:0 auto; margin:auto; width: <%=(widthMedoidTable + 100)%>px;">
        <tr>
            <td>
                <table id="projectionTable" style="text-align: center; margin:0 auto; margin:auto; width: <%=(widthMedoidTable + 100)%>px;">
                    <tr>
                        <td>
                            <b>VARIABLE PROJECTION</b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div style="text-align:center;">
                         <input  style="width:130px;" type="range" name="hierarchicalLevelRange" 
                                        id="hierarchicalLevelRange" min="1" max="101" step="10" value="<%=hierarchicalLevelRange%>" 
                                        onchange="updateHierarchicalProjectionHierarchicalMatrices();" >
                            </div></td>
                    </tr>


                    <tr>
                        <td style="text-align: left;">
                            Fixed:
                            <input type="checkbox" name="blockProjectionVisualizationCheckBox" 
                                   id="blockProjectionVisualizationCheckBox"
                                   onchange="blockHierarchicalProjectionVisualization();">
                        </td>
                    </tr>
                    <tr>
                        <td style="width:1240px;">
                            <div id="generalProjectionContent" >  
                                <script type="text/javascript"> createHierarchicalProjectionHierachicalMatrices("generalProjectionContent",
                                "1190", "240", "<%=datasetProjection%>", "<%=numberMaxGroup%>", "<%=arrayMembers%>", "<%=arrayMedoids%>");</script> 
                            </div>
                        </td>
                    </tr>


                </table>
            </td></tr>
        <tr><td>
                <table  id="timeMatricesTable" style="text-align: center;margin:0 auto; margin:auto; " >
                    <br>
                    <tr>
                        <td colspan="2">
                            <table style="text-align: center; margin:0 auto; margin:auto; width: <%=(widthMedoidTable + 100)%>px;">
                                <tr>
                                    <td  colspan="2">Cell Value</td>
                                </tr>
                                <tr>
                                    <td  colspan="2">
                                        <table border="0" style=" text-align: center; background-color:  #ffffff; width:900px;   margin:0 auto; margin:auto;" >
                                            <tr>
                                                <td>(0)</td>
                                                <%                Color colorScale = Color.WHITE;
                                                    for (int i = colorScaleCell.length - 1; i >= 0; i--) {
                                                        colorScale = colorScaleCell[i];
                                                %>
                                                <td  style="background-color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);"
                                                     width="4px" height="6px"></td>
                                                <%
                                                    }
                                                %>
                                                <td>(1)</td>
                                            </tr>
                                        </table>
                                        <br>
                                    </td>
                                </tr>
                                <tr>
                                    <td  colspan="2">Missing Data(%)</td>
                                </tr>
                                <!--tr>
                                    <td  colspan="2">
                                        <table border="0" style=" text-align: center; background-color:  #ffffff; width:900px;   margin:0 auto; margin:auto;" >
                                            <tr>
                                                <td>(0%)</td>
                                <%  //              Color colorMissingData = Color.WHITE;
                                    // for (int i = 0; i < colorScaleBorder.length; i++) {
                                    //    colorMissingData = colorScaleBorder[i];
                                %>
                                <td  style="background-color: rgb(<%//out.print(colorMissingData.getRed());%>,<%//out.print(colorMissingData.getGreen());%>,<%//out.print(colorMissingData.getBlue());%>);color: rgb(
                                <%//out.print(colorScale.getRed());%>,<%//out.print(colorScale.getGreen());%>,<%//out.print(colorScale.getBlue());%>);"
                                                     width="4px" height="6px"></td>
                                <%
                        // }
%>
                                                                                                                                    <td>(100%)</td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                            <br>
                                                                                                                        </td>
                                                                                                                    </tr-->
                                <tr>

                                    <td   colspan="2">
                                        <table style="margin:0 auto; margin:auto;">
                                            <tr>
                                                <td colspan="3"> <input type="text" id="missingDataThresholdInput" readonly value="0%" style="border:0;text-align: center;">
                                                </td>

                                            </tr>
                                            <tr><td>0</td>
                                                <td>
                                                    <input type="range" id="missingDataSlider" name="missingDataSlider" value="100" min="0" max="100"  style="width: 500px;"
                                                           oninput="updateMissingDataThresholdHierarchical('<%=currentMedoidTimeMatrices.size()%>', '<%=currentMemberTimeMatrices.size()%>', '<%=arrayMembers%>', '<%=arrayMedoids%>');" 
                                                           onchange="updateMissingDataThresholdHierarchical('<%=currentMedoidTimeMatrices.size()%>', '<%=currentMemberTimeMatrices.size()%>', '<%=arrayMembers%>', '<%=arrayMedoids%>');"></td>
                                                <!--td style="width: 10px;"></td><td> &nbsp<div id="missingDataSlider" style="width: 500px" ></div>&nbsp</td><td style="width: 10px;"></td-->
                                                <td>100</td>
                                            </tr>
                                        </table>
                                    </td>
                                <tr>


                                <tr>
                                    <td>
                                        <table style="margin:0 auto; margin:auto;" border="1">
                                            <%
                                                int countMedoids = 0;
                                                for (int i = 0; i < numMedoidRows; i++) {

                                            %>  
                                            <tr>
                                                <%  for (int j = 0; j < numMedoidCols && countMedoids < currentMedoidTimeMatrices.size(); j++) {

                                                        String nameAttribute = currentMedoidTimeMatrices.get(countMedoids).getNameAttribute();
                                                        Color colorBackground = colorScaleBackground[currentMedoidTimeMatrices.get(countMedoids).getIndexColorCluster()];
                                                        String fontColor = utils.Util.getColorByLuminance(colorBackground);
                                                        ArrayList<Integer> listSubMembers = new ArrayList<Integer>();
                                                        if (currentClusteringNode.getListChildNodes() != null && (currentClusteringNode.getListChildNodes().size() > countMedoids)) {
                                                            listSubMembers = currentClusteringNode.getListChildNodes().get(countMedoids).getListMembers();
                                                        }
                                                        String memberIdsString = "";
                                                        for (int p = 0; p < listSubMembers.size() - 1; p++) {
                                                            memberIdsString += listSubMembers.get(p) + ",";
                                                        }
                                                        memberIdsString += listSubMembers.get(listSubMembers.size() - 1);
                                                        /* String entireListChildren = listSubMembers.size() + ": \n";
                                                        for (int p = 0; p < listSubMembers.size(); p++) {
                                                            entireListChildren += listTimeIntervals.get(listSubMembers.get(p)).getNameAttribute() + "\n";
                                                        }*/
                                                        int borderWidth = 5;//10-
                                                 

                                                %>
                                                <td style=" background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>); width: <%=widthMedoidTable%>px;text-align:center;" >
                                                    <table id="matrixMemberMedoid<%=listMedoids.get(countMedoids)%>" style="text-align: center; border-style: solid;border-width: <%=borderWidth%>px; 
                                                            width: <%=widthMedoidTable%>px;border-color:#A8A8A8;" >
                                                       <tr>
                                                           <td>
                                                    <table  id="matrixMedoid<%=countMedoids%>" style="text-align: center; border-style: solid;border-width: <%=borderWidth%>px; 
                                                            width: <%=widthMedoidTable%>px;border-color:#A8A8A8;" 
                                                            ondblclick="focusProjectionHierarchicalMembers('<%=countMedoids%>','<%=listMedoids.get(countMedoids)%>', '<%=currentMemberTimeMatrices.size()%>', '<%=memberIdsString%>');">
                                                        <tr >
                                                            <th  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                Cluster# <%=currentMedoidTimeMatrices.get(countMedoids).getCluster()%>

                                                                - <%out.print(nameAttribute);%> 
                                                                <button  style="color: black;" type="button"  onclick="exploreHierarchicalTimeMatrices('<%=countMedoids%>', 'false');" >+</button>
                                                                <button style="color: black;" type="button"  onclick="exploreHierarchicalTimeMatrices('<%="parent"%>', 'false');">-</button>
                                                                <button style="color: black;" type="button"  onclick="exploreHierarchicalTimeMatrices('<%="root"%>', 'false');">root</button>
                                                                
                                                                <!--button  style="color: black;" type="button" title="<//=entireListChildren>"  onclick="exploreHierarchicalTimeMatrices('//=countMedoids', 'true');">see</button-->
                                                            </th>
                                                        </tr>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:13px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(currentMedoidTimeMatrices.get(countMedoids).getNameSource() + " " + currentMedoidTimeMatrices.get(countMedoids).getValueSource());%></td>
                                                        </tr>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(currentMedoidTimeMatrices.get(countMedoids).getInitDate() + " - " + currentMedoidTimeMatrices.get(countMedoids).getEndDate() + " : "
                                                                + currentMedoidTimeMatrices.get(countMedoids).getInitHour() + " - " + currentMedoidTimeMatrices.get(countMedoids).getEndHour());%></td>
                                                        </tr>

                                                        <% Matrix matrixTmp = currentMedoidTimeMatrices.get(countMedoids).getMatrix();
                                                            ArrayList<String> listX = currentMedoidTimeMatrices.get(countMedoids).getListLabelsX();
                                                            ArrayList<String> listY = currentMedoidTimeMatrices.get(countMedoids).getListLabelsY();
                                                            double maxValue = Math.round(matrixTmp.getMaxValue() * 100) / 100;
                                                            double minValue = Math.round(matrixTmp.getMinValue() * 100) / 100;
                                                        %>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;
                                                                 color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print("Min value: " + minValue + " - Max value: " + maxValue);%></td>
                                                        </tr>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(" Missing data: " + currentMedoidTimeMatrices.get(countMedoids).getOriginalMissingDataImpact() + "%");%></td>
                                                        </tr>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(" With interpolation: " + currentMedoidTimeMatrices.get(countMedoids).getInterpolatedMissingDataImpact() + "%");%></td>
                                                        <input id="missingDataMedoid<%=countMedoids%>" hidden="hidden" value="<%=currentMedoidTimeMatrices.get(countMedoids).getOriginalMissingDataImpact()%>">
                                                        </tr>
                                                        <tr><td style="text-align: center;" ><table style='font-size:3px; border-style:solid; margin:0 auto; margin:auto;'  >
                                                                    <%

                                                                        for (int mRow = 0; mRow < matrixTmp.getRows(); mRow++) {%>
                                                                    <tr><%for (int mCol = 0; mCol < matrixTmp.getCols(); mCol++) {
                                                                            int positionColorCell = (int) matrixTmp.getValue(mRow, mCol);
                                                                            Double originalValue = Double.NaN;
                                                                            if (matrixTmp.getOriginalValue(mRow, mCol) != Double.NEGATIVE_INFINITY && matrixTmp.getValue(mRow, mCol) != Double.NEGATIVE_INFINITY) {
                                                                                originalValue = matrixTmp.getOriginalValue(mRow, mCol);
                                                                            }

                                                                            boolean interpolatedFlag = (boolean) matrixTmp.getFlag(mRow, mCol);
                                                                            Color colorCell = Color.WHITE;
                                                                            if (positionColorCell >= 0) {
                                                                                colorCell = colorScaleCell[255 - positionColorCell];
                                                                            } else {
                                                                                colorCell = Color.gray;
                                                                            }

                                                                            if (originalValue.isNaN() && colorCell != Color.gray) {

                                                                                Double valueInterpolated = Operations.minmax((positionColorCell) * 1.0, 0.0, 255.0, matrixTmp.getMinValue(), matrixTmp.getMaxValue());
                                                                                originalValue = (Math.round(valueInterpolated * 100.0)) / 100.0;
                                                                            }
                                                                            int red = colorCell.getRed();
                                                                            int green = colorCell.getGreen();
                                                                            int blue = colorCell.getBlue();
                                                                        %>
                                                                        <td title="<%out.print(listY.get(mRow) + "\n" + listX.get(mCol) + " \n" + aggregationFunction + " value: " + originalValue + " in " + valueUnitTimeInterval + " " + unitTimeInterval);%>"   
                                                                            style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                                                                            color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                                                                            <%if (interpolatedFlag == true) {
                                                                            %>
                                                                            border: 1px solid red;
                                                                            <%}%>" 
                                                                            width="<%out.print(sizeMedoidCellWidth);%>px" height="<%out.print((sizeMedoidCellHeight));%>px">

                                                                        </td>
                                                                        <% }%>
                                                                    </tr>
                                                                    <% }%>
                                                                </table></td>
                                                        </tr>
                                                    </table>
                                                           </td></tr>
                                                    </table>
                                                </td>
                                                <%     countMedoids++;
                                                %>

                                                <% } %>
                                            </tr>
                                            <%
                                    }%>
                                        </table>
                                    </td>

                                </tr>
                                <tr style="height: 10px;">
                                </tr>
                                <tr>
                                    <td style="height: 10px;color:black;background:black;">


                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <table style="margin:0 auto; margin:auto;" border="1">
                                            <%
                                                int numMemberCols = 10;

                                                if (numMemberCols > currentMemberTimeMatrices.size()) {
                                                    numMemberCols = currentMemberTimeMatrices.size();
                                                }

                                                int numMemberRows = (int) Math.ceil(currentMemberTimeMatrices.size() * 1.0 / numMemberCols);

                                                int sizeMemberCellWidth = (int) Math.ceil(150 / currentMemberTimeMatrices.get(0).getMatrix().getCols()) + 3;
                                                int sizeMemberCellHeight = (int) Math.ceil(87 / currentMemberTimeMatrices.get(0).getMatrix().getRows()) + 3;

                                                if (sizeMemberCellWidth < 3) {
                                                    sizeMemberCellWidth = 3;
                                                }
                                                if (sizeMemberCellHeight < 3) {
                                                    sizeMemberCellHeight = 3;
                                                }

                                                int widthMemberTable = sizeMemberCellWidth * currentMemberTimeMatrices.get(0).getMatrix().getCols() + 10;
                                                if (widthMemberTable < 140) {
                                                    widthMemberTable = 140;
                                                }

                                                int countMembers = 0;
                                                for (int i = 0; i < numMemberRows; i++) {

                                            %>  
                                            <tr>
                                                <%  for (int j = 0; j < numMemberCols && countMembers < currentMemberTimeMatrices.size(); j++) {

                                                        String nameAttribute = currentMemberTimeMatrices.get(countMembers).getNameAttribute();
                                                        Color colorBackground = colorScaleBackground[currentMemberTimeMatrices.get(countMembers).getIndexColorCluster()];
                                                        String fontColor = utils.Util.getColorByLuminance(colorBackground);

                                                        int borderWidth = 5;//10-

                                                %>
                                                <td style=" background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>); width: <%=widthMemberTable%>px;text-align:center;" >

                                                    <table id="matrixMemberMember<%=listMembers.get(countMembers)%>" style="text-align: center; border-style: solid;border-width: <%=borderWidth%>px; width: <%=widthMemberTable%>px;border-color:#A8A8A8;">
                                                        <tr><td>
                                                    <table  id="matrixMember<%=countMembers%>" style="text-align: center; border-style: solid;border-width: <%=borderWidth%>px; width: <%=widthMemberTable%>px;border-color:#A8A8A8;"
                                                            
                                                            >
                                                        <tr >
                                                            <th  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:13px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                Cluster# <%=currentMemberTimeMatrices.get(countMembers).getCluster()%>
                                                                - <%out.print(nameAttribute);%> 
                                                                <input id="idMember<%=countMembers%>" hidden="hidden" value="<%=listMembers.get(countMembers)%>">
                                                            </th>
                                                        </tr>

                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(currentMemberTimeMatrices.get(countMembers).getNameSource() + " " + currentMemberTimeMatrices.get(countMembers).getValueSource());%></td>
                                                        </tr>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:11px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(currentMemberTimeMatrices.get(countMembers).getInitDate() + " - " + currentMemberTimeMatrices.get(countMembers).getEndDate() + " : "
                                                                + currentMemberTimeMatrices.get(countMembers).getInitHour() + " - " + currentMemberTimeMatrices.get(countMembers).getEndHour());%></td>
                                                        </tr>

                                                        <% Matrix matrixTmp = currentMemberTimeMatrices.get(countMembers).getMatrix();
                                                            ArrayList<String> listX = currentMemberTimeMatrices.get(countMembers).getListLabelsX();
                                                            ArrayList<String> listY = currentMemberTimeMatrices.get(countMembers).getListLabelsY();
                                                            double maxValue = Math.round(matrixTmp.getMaxValue() * 100) / 100;
                                                            double minValue = Math.round(matrixTmp.getMinValue() * 100) / 100;
                                                        %>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:11px;
                                                                 color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print("Min value: " + minValue + " - Max value: " + maxValue);%></td>
                                                        </tr>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:11px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(" Missing data: " + currentMemberTimeMatrices.get(countMembers).getOriginalMissingDataImpact() + "%");%></td>
                                                        </tr>
                                                        <tr >
                                                            <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:11px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                                <%out.print(" With interpolation: " + currentMemberTimeMatrices.get(countMembers).getInterpolatedMissingDataImpact() + "%");%></td>
                                                        <input id="missingDataMember<%=countMembers%>" hidden="hidden" value="<%=currentMemberTimeMatrices.get(countMembers).getOriginalMissingDataImpact()%>">
                                                        </tr>
                                                        <tr><td style="text-align: center;" ><table style='font-size:3px; border-style:solid; margin:0 auto; margin:auto;'  >
                                                                    <%

                                                                        for (int mRow = 0; mRow < matrixTmp.getRows(); mRow++) {%>
                                                                    <tr><%for (int mCol = 0; mCol < matrixTmp.getCols(); mCol++) {
                                                                            int positionColorCell = (int) matrixTmp.getValue(mRow, mCol);
                                                                            Double originalValue = Double.NaN;
                                                                            if (matrixTmp.getOriginalValue(mRow, mCol) != Double.NEGATIVE_INFINITY && matrixTmp.getValue(mRow, mCol) != Double.NEGATIVE_INFINITY) {
                                                                                originalValue = matrixTmp.getOriginalValue(mRow, mCol);
                                                                            }

                                                                            boolean interpolatedFlag = (boolean) matrixTmp.getFlag(mRow, mCol);
                                                                            Color colorCell = Color.WHITE;
                                                                            if (positionColorCell >= 0) {
                                                                                colorCell = colorScaleCell[255 - positionColorCell];
                                                                            } else {
                                                                                colorCell = Color.gray;
                                                                            }

                                                                            if (originalValue.isNaN() && colorCell != Color.gray) {

                                                                                Double valueInterpolated = Operations.minmax((positionColorCell) * 1.0, 0.0, 255.0, matrixTmp.getMinValue(), matrixTmp.getMaxValue());
                                                                                originalValue = (Math.round(valueInterpolated * 100.0)) / 100.0;
                                                                            }
                                                                            int red = colorCell.getRed();
                                                                            int green = colorCell.getGreen();
                                                                            int blue = colorCell.getBlue();
                                                                        %>
                                                                        <td title="<%out.print(listY.get(mRow) + "\n" + listX.get(mCol) + " \n" + aggregationFunction + " value: " + originalValue + " in " + valueUnitTimeInterval + " " + unitTimeInterval);%>"   
                                                                            style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                                                                            color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                                                                            <%if (interpolatedFlag == true) {
                                                                            %>
                                                                            border: 1px solid red;
                                                                            <%}%>" 
                                                                            width="<%out.print(sizeMemberCellWidth);%>px" height="<%out.print((sizeMemberCellHeight));%>px">

                                                                        </td>
                                                                        <% }%>
                                                                    </tr>
                                                                    <% }%>
                                                                </table></td>
                                                        </tr>
                                                    </table>
                                                            </td></tr></table>
                                                </td>
                                                <%     countMembers++;
                                                %>

                                                <% } %>
                                            </tr>
                                            <%
                                    }%>
                                        </table>
                                    </td>


                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

    </table>
</div>



<%}
} else {%><br>
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

<%  }%>