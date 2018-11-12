<%-- 
    Document   : index
    Created on : Feb 15, 2016, 4:19:07 PM
    Author     : aurea
--%>

<%@page import="utils.Operations"%>
<%@page import="color.BTC"%>
<%@page import="java.util.Arrays"%>
<%@page import="dataMaker.Matrix"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    ArrayList<TimeInterval> listTimeIntervalsData1 = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    ArrayList<Integer> listSelectedAttributesSubset1 = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
    String valueType = (String) session.getAttribute("aggregationFunction");
    String selectedAttributes1 = (String) session.getAttribute("selectedAttributes");
    String[] selectedAttributesArray1 = selectedAttributes1.split(",");

    Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
    Color[] colorScaleCell = (Color[]) session.getAttribute("colorScaleCell");

    int numberCols = 4;
    if (numberCols > listSelectedAttributesSubset1.size()) {
        numberCols = listSelectedAttributesSubset1.size();
    }

    int numberRows = (int) Math.ceil(listSelectedAttributesSubset1.size() * 1.0 / numberCols);
    Color[] colorScaleBorder = (new BTC()).getColorScale();

    // int totalWidth = 1200;
    // int localWidth = totalWidth / numberCols;

%>
<br>
<table style="margin:0 auto; margin:auto;   border-color: black;  "  border="1"  >
    <%        int countListAttributes = 0;
        for (int i = 0; i < numberRows && countListAttributes < listSelectedAttributesSubset1.size(); i++) {%>
    <tr>
        <% for (int j = 0; j < numberCols && countListAttributes < listSelectedAttributesSubset1.size(); j++) {
                int indexAttribute = listSelectedAttributesSubset1.get(countListAttributes);
                // System.out.println(listSelectedAttributesSubset1.get(countListAttributes) +"- "+listTimeIntervalsData1.get(indexAttribute).getNameAttribute());
                int indexColorBackground = listTimeIntervalsData1.get(indexAttribute).getIndexColorCluster();
                Color colorBackground = colorScaleBackground[indexColorBackground];
                String fontColor = utils.Util.getColorByLuminance(colorBackground);
                int borderWidth = 5;//10-
                Color borderColor;
                int colorBorderValue = (int) Math.round(Operations.minmax(listTimeIntervalsData1.get(indexAttribute).getOriginalMissingDataImpact(), 0.f, 100.f, 1.f, 250.f));

                borderColor = colorScaleBorder[colorBorderValue];

        %>


        <td style="width: 400px;height: 400px; text-align: center; ">
            <table style="border-style: solid; border-color: rgb(<%out.print(borderColor.getRed());%>,<%out.print(borderColor.getGreen());%>,<%out.print(borderColor.getBlue());%>);
                   border-width: <%=borderWidth%>px;text-align: center; margin:0 auto; margin:auto;
                   background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>);">
                <tr >
                    <th  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;' >
                         <%out.print("Cluster# "+listTimeIntervalsData1.get(indexAttribute).getCluster()+" - "+listTimeIntervalsData1.get(indexAttribute).getNameAttribute());%>       
                    </th>
                </tr>
                <tr >
                    <td " style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:13px;color:<%out.print(fontColor);%>;text-align:center;'  >
                        <%out.print(listTimeIntervalsData1.get(indexAttribute).getNameSource() + " " + listTimeIntervalsData1.get(indexAttribute).getValueSource());%></td>
                </tr>
                <tr >
                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' >
                        <%out.print(listTimeIntervalsData1.get(indexAttribute).getInitDate() + " - " + listTimeIntervalsData1.get(indexAttribute).getEndDate()); %></td>
                </tr>

                <tr >
                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;
                         color:<%out.print(fontColor);%>;text-align:center;'  >
                        <%out.print("Min value: " + listTimeIntervalsData1.get(indexAttribute).getMatrix().getMinValue() + " - Max value: " + listTimeIntervalsData1.get(indexAttribute).getMatrix().getMaxValue());%></td>
                </tr>
                <tr >
                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;'  >
                        <%out.print(" Missing data: " + listTimeIntervalsData1.get(indexAttribute).getOriginalMissingDataImpact() + "%");%></td>
                </tr>
                <tr >
                    <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' >
                        <%out.print(" With interpolation: " + listTimeIntervalsData1.get(indexAttribute).getInterpolatedMissingDataImpact() + "%");%></td>
                </tr>
                <tr>

                    <td style="width: 400px; height: 400px;background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>);" >
                        <table style='font-size:3px;width: 400px; height: 400px; border-style:solid;' >
                            <%
                                Matrix matrixTmp = listTimeIntervalsData1.get(indexAttribute).getMatrix();
                                ArrayList<String> listX = listTimeIntervalsData1.get(indexAttribute).getListLabelsX();
                                ArrayList<String> listY = listTimeIntervalsData1.get(indexAttribute).getListLabelsY();
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
                                <td title="<%out.print(listY.get(mRow) + "\n" + listX.get(mCol) + " \n" + valueType + " value: " + originalValue);%>" 
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
                        </table>
                    </td>



                </tr>
            </table>

        </td>
        <%
                countListAttributes++;
            }%>
    </tr>
    <%}%>
</table>
