<%-- 
    Document   : ItemMatrixCluster
    Created on : Apr 5, 2016, 5:31:04 PM
    Author     : aurea
--%>

<%@page import="utils.Operations"%>
<%@page import="color.BTC"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dataMaker.Matrix"%>

<%int idTimeMatrix = Integer.valueOf(request.getParameter("idTimeMatrix"));
    Color[] colorScaleCell1 = (Color[]) session.getAttribute("colorScaleCell");
    Color[] colorScaleBackground1 = (Color[]) session.getAttribute("colorScaleBackground");
    ArrayList<TimeInterval> listTimeIntervalsData1 = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    String valueType = (String) session.getAttribute("option");
    Matrix matrixTmp = listTimeIntervalsData1.get(idTimeMatrix).getMatrix();
    ArrayList<String> listX = listTimeIntervalsData1.get(idTimeMatrix).getListLabelsX();
    ArrayList<String> listY = listTimeIntervalsData1.get(idTimeMatrix).getListLabelsY();
    int indexColorBackground = listTimeIntervalsData1.get(idTimeMatrix).getIndexColorCluster();
    Color colorBackground = colorScaleBackground1[indexColorBackground];
    String fontColor = utils.Util.getColorByLuminance(colorBackground);
    double sizeCellWidth = (380) / matrixTmp.getCols();
    double sizeCellHeight = (380) / matrixTmp.getRows();
    Color[] colorScaleBorder = (new BTC()).getColorScale();
    int borderWidth = 5;//10-
    Color borderColor;
    int colorBorderValue = (int) Math.round(Operations.minmax(listTimeIntervalsData1.get(idTimeMatrix).getOriginalMissingDataImpact(), 0.f, 100.f, 1.f, 250.f));

    borderColor = colorScaleBorder[colorBorderValue];
%>


<table style=" border-style: solid; border-color: rgb(<%out.print(borderColor.getRed());%>,<%out.print(borderColor.getGreen());%>,<%out.print(borderColor.getBlue());%>);border-width: <%=borderWidth%>px;
       text-align: center; margin:0 auto; margin:auto;">
    <tr >
        <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
            <%out.print(listTimeIntervalsData1.get(idTimeMatrix).getNameAttribute());%></td>
    </tr>
    <tr >
        <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:13px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
            <%out.print(listTimeIntervalsData1.get(idTimeMatrix).getNameSource() + " " + listTimeIntervalsData1.get(idTimeMatrix).getValueSource());%></td>
    </tr>
    <tr >
        <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
            <%out.print(listTimeIntervalsData1.get(idTimeMatrix).getInitDate() + " - " + listTimeIntervalsData1.get(idTimeMatrix).getEndDate());%></td>
    </tr>
    <tr >
        <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;
             color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
            <%out.print("Min value: " + listTimeIntervalsData1.get(idTimeMatrix).getMatrix().getMinValue() + " - Max value: " + listTimeIntervalsData1.get(idTimeMatrix).getMatrix().getMaxValue());%></td>
    </tr>
    <tr >
        <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
            <%out.print(" Missing data: " + listTimeIntervalsData1.get(idTimeMatrix).getOriginalMissingDataImpact() + "%");%></td>
    </tr>
    <tr >
        <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
            <%out.print(" With interpolation: " + listTimeIntervalsData1.get(idTimeMatrix).getInterpolatedMissingDataImpact() + "%");%></td>
    </tr>

    <tr>                          <td>  
            <table style='font-size:3px;width: 380px; height:380px; border-style:solid;' >
                <%
                    for (int mRow = 0; mRow < matrixTmp.getRows(); mRow++) {%>
                <tr><%for (int mCol = 0; mCol < matrixTmp.getCols(); mCol++) {
                        int positionColorCell = (int) matrixTmp.getValue(mRow, mCol);
                        boolean interpoledFlag = (boolean) matrixTmp.getFlag(mRow, mCol);
                        double originalValue = Double.NaN;
                        if (matrixTmp.getOriginalValue(mRow, mCol) != Double.NEGATIVE_INFINITY && matrixTmp.getValue(mRow, mCol) != Double.NEGATIVE_INFINITY) {
                            originalValue = matrixTmp.getOriginalValue(mRow, mCol);
                        }
                        Color colorCell = null;
                        if (positionColorCell >= 0) {
                            colorCell = colorScaleCell1[255 - positionColorCell];
                        } else {
                            colorCell = Color.gray;
                        }

                        int red1 = colorCell.getRed();
                        int green1 = colorCell.getGreen();
                        int blue1 = colorCell.getBlue();
                        //background-color: rgb(out.print(colorCell.getRed());,out.print(colorCell.getGreen());,<%out.print(colorCell.getBlue()););
                    %>
                    <td title="<%out.print(listY.get(mRow) + "\n" + listX.get(mCol) + " \n" + valueType + " value: " + originalValue);%>" 
                        style="background-color: rgb(<%out.print(red1);%>,<%out.print(green1);%>,<%out.print(blue1);%>); 
                        color:rgb(<%out.print(red1);%>,<%out.print(green1);%>,<%out.print(blue1);%>);  
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
</table>




