<%-- 
    Document   : index
    Created on : Feb 15, 2016, 4:19:07 PM
    Author     : aurea
--%>

<%@page import="color.BTC"%>
<%@page import="utils.Operations"%>
<%@page import="dataMaker.Matrix"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    ArrayList<ArrayList<Integer>> resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
    String aggregationFunction = (String) session.getAttribute("aggregationFunction");
    int[] listMedoids = (int[]) session.getAttribute("listMedoids");
    Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
    Color[] colorScaleCell = (Color[]) session.getAttribute("colorScaleCell");

    int numberCols = 3;
    if (numberCols > resultClustering.size()) {
        numberCols = resultClustering.size();
    }

    int numberRows = (int) Math.ceil(resultClustering.size() * 1.0 / numberCols);

    // int totalWidth = 1200;
    // int localWidth = totalWidth / numberCols;
    Color[] colorScaleBorder = (new BTC()).getColorScale();

%>
<br>
<table style="margin:0 auto; margin:auto; border-color: black;"    border="1">
    <%        int countClusters = 1;
        for (int i = 0; i < numberRows && countClusters <= resultClustering.size(); i++) {%>
    <tr>
        <% for (int j = 0; j < numberCols && countClusters <= resultClustering.size(); j++) {

                int indexMedoid = listMedoids[countClusters - 1];
                int indexColorBackground = listTimeIntervalsData.get(indexMedoid).getIndexColorCluster();
                Color colorBackground = colorScaleBackground[indexColorBackground];
                String fontColor = utils.Util.getColorByLuminance(colorBackground);
                int borderWidth = 5;//10-
                Color borderColor;
                int colorBorderValue = (int) Math.round(Operations.minmax(listTimeIntervalsData.get(indexMedoid).getOriginalMissingDataImpact(), 0.f, 100.f, 1.f, 250.f));

                borderColor = colorScaleBorder[colorBorderValue];

        %>


        <td style="width: 460px; text-align: center; ">

            <table style="text-align: center; margin:0 auto; margin:auto;
                   background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>);">
                <tr >
                    <th  style="font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;" colspan="2" >Cluster <%out.print(listTimeIntervalsData.get(indexMedoid).getCluster());%></th>
                </tr>

                <tr>

                    <td style=" width: 380px; height: 380px;background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>);" >

                        <div id="Cluster<%out.print(listTimeIntervalsData.get(indexMedoid).getCluster());%>">
                            <table style="border-style: solid; border-color: rgb(<%out.print(borderColor.getRed());%>,<%out.print(borderColor.getGreen());%>,<%out.print(borderColor.getBlue());%>);
                        border-width: <%=borderWidth%>px;text-align: center; margin:0 auto; margin:auto;">
                                <tr >
                                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                        <%out.print(listTimeIntervalsData.get(indexMedoid).getNameAttribute());%></td>
                                </tr>
                                <tr >
                                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:13px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                        <%out.print(listTimeIntervalsData.get(indexMedoid).getNameSource() + " " + listTimeIntervalsData.get(indexMedoid).getValueSource());%></td>
                                </tr>
                                <tr >
                                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                        <%out.print(listTimeIntervalsData.get(indexMedoid).getInitDate() + " - " + listTimeIntervalsData.get(indexMedoid).getEndDate());%></td>
                                </tr>
                                <tr >
                                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;
                                         color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                        <%out.print("Min value: " + listTimeIntervalsData.get(indexMedoid).getMatrix().getMinValue() + " - Max value: " + listTimeIntervalsData.get(indexMedoid).getMatrix().getMaxValue());%></td>
                                </tr>
                                <tr >
                                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                        <%out.print(" Missing data: " + listTimeIntervalsData.get(indexMedoid).getOriginalMissingDataImpact() + "%");%></td>
                                </tr>
                                <tr >
                                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                        <%out.print(" With interpolation: " + listTimeIntervalsData.get(indexMedoid).getInterpolatedMissingDataImpact() + "%");%></td>
                                </tr>

                                <tr>                          <td>  <table style='font-size:3px;width: 380px; height: 380px; border-style:solid;' >
                                            <%
                                                Matrix matrixTmp = listTimeIntervalsData.get(indexMedoid).getMatrix();
                                                ArrayList<String> listX = listTimeIntervalsData.get(indexMedoid).getListLabelsX();
                                                ArrayList<String> listY = listTimeIntervalsData.get(indexMedoid).getListLabelsY();
                                                double sizeCellWidth = (300) / matrixTmp.getCols();
                                                double sizeCellHeight = (270) / matrixTmp.getRows();
                                                if (sizeCellWidth < 3) {
                                                    sizeCellWidth = 3;
                                                }
                                                if (sizeCellHeight < 3) {
                                                    sizeCellHeight = 3;
                                                }
                                                for (int mRow = 0; mRow < matrixTmp.getRows(); mRow++) {%>
                                            <tr><%for (int mCol = 0; mCol < matrixTmp.getCols(); mCol++) {
                                                    int positionColorCell = (int) matrixTmp.getValue(mRow, mCol);
                                                    boolean interpoledFlag = (boolean) matrixTmp.getFlag(mRow, mCol);
                                                    Double originalValue = Double.NaN;
                                                    if (matrixTmp.getOriginalValue(mRow, mCol) != Double.NEGATIVE_INFINITY && matrixTmp.getValue(mRow, mCol) != Double.NEGATIVE_INFINITY) {
                                                        originalValue = matrixTmp.getOriginalValue(mRow, mCol);
                                                    }
                                                    Color colorCell = null;
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
                                                    //background-color: rgb(out.print(colorCell.getRed());,out.print(colorCell.getGreen());,<%out.print(colorCell.getBlue()););
                                                %>
                                                <td title="<%out.print(listY.get(mRow) + "\n" + listX.get(mCol) + " \n" + aggregationFunction + " value: " + originalValue);%>" 
                                                    style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                                                    color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>);  
                                                    <%if (interpoledFlag == true) {
                                                    %>
                                                    border: 1px solid red;
                                                    <%}%>"
                                                    width="<%out.print(sizeCellWidth);%>px" height="<%out.print(sizeCellHeight);%>px">

                                                </td>
                                                <% }%>
                                            </tr>
                                            <% }%>
                                        </table></td>
                                </tr>
                            </table></div>
                    </td>
                    <td style="width: 120px; ">
                        <select id="listAttributesSelect<%=(listTimeIntervalsData.get(indexMedoid).getCluster())%>" name="listAttributesSelect<%=(listTimeIntervalsData.get(indexMedoid).getCluster())%>"   
                                style="width: 120px; height:420px;  overflow-x: scroll;" multiple="multiple" onchange="updateMatrixCluster('<%=(listTimeIntervalsData.get(indexMedoid).getCluster())%>');">
                            <option value="<%=indexMedoid%>" 

                                    ondblclick="addRemoveAttributeSubsetSelection2('<%=indexMedoid%>');" style="color: red;" > <%=listTimeIntervalsData.get(indexMedoid).getNameAttribute() + "- " + listTimeIntervalsData.get(indexMedoid).getNameSource() + " " + listTimeIntervalsData.get(indexMedoid).getValueSource() + "-" + listTimeIntervalsData.get(indexMedoid).getInitHour() + ":00-" + listTimeIntervalsData.get(indexMedoid).getEndHour() + ":00"%></option>

                            <% for (int elem = 0; elem < resultClustering.get(countClusters - 1).size(); elem++) {
                                    int indexElemTmp = resultClustering.get(countClusters - 1).get(elem);

                                    if (indexElemTmp != indexMedoid) {%>
                            <option value="<%=indexElemTmp%>" 

                                    ondblclick="addRemoveAttributeSubsetSelection2('<%=indexElemTmp%>');"> <%=listTimeIntervalsData.get(indexElemTmp).getNameAttribute() + "- " + listTimeIntervalsData.get(indexMedoid).getNameSource() + " " + listTimeIntervalsData.get(indexElemTmp).getValueSource() + "-" + listTimeIntervalsData.get(indexElemTmp).getInitHour() + ":00-" + listTimeIntervalsData.get(indexElemTmp).getEndHour() + ":00"%></option>
                            <%}
                                }%>




                        </select></td>


                </tr>
            </table>

        </td>
        <%
                countClusters++;
            }%>
    </tr>
    <%}%>
</table>
