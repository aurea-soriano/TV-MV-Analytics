<%-- 
    Document   : CorrelationMatrixSubsetAttributes
    Created on : Mar 10, 2016, 3:21:20 PM
    Author     : aurea
--%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Arrays"%>
<%@page import="utils.Util"%>
<%@page import="color.BTC"%>
<%@page import="color.HeatedObject"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");

    ArrayList<Integer> listSelectedAttributesSubset1 = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");

    String selectedAttributes1 = (String) session.getAttribute("selectedAttributes");
    String[] selectedAttributesArray1 = selectedAttributes1.split(",");

    int[] indices = new int[listSelectedAttributesSubset1.size()];
    for (int i = 0; i < listSelectedAttributesSubset1.size(); i++) {
        indices[i] = listSelectedAttributesSubset1.get(i);
    }

    int[][] matrixColorCorrelationSubset = Util.calculateColorCorrelationMatrix(indices, listTimeIntervalsData);
    Color[] colorScalePositive = (new HeatedObject()).getColorScale();
    Color[] colorScaleNegative = (new BTC()).getColorScale();
    Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
    double sizeCell = (550) / matrixColorCorrelationSubset.length;
    if (matrixColorCorrelationSubset.length > 550) {
        sizeCell = 1;
    }
%>
<div id="dialog-form"  title="Add or remove attribute:" hidden>
    <input type="radio" id="RadioCorrelationSubsetAttribute1" name="RadioCorrelationSubsetAttribute" ><label id="LabelCorrelationSubsetAttribute1" ></label> <br>
    <input type="radio" id="RadioCorrelationSubsetAttribute2" name="RadioCorrelationSubsetAttribute" > <label id="LabelCorrelationSubsetAttribute2" ></label><br>
</div>
<br>


<table  style="margin:0 auto; margin:auto; ">
    <tr>
        <td  colspan="2">
            <table border="0" style=" text-align: center; background-color:  #ffffff; width:800px;   margin:0 auto; margin:auto;" >
                <tr>
                    <td>-</td>
                    <%                Color colorScale = Color.WHITE;
                        for (int i = 0; i < colorScaleNegative.length; ++i) {
                            colorScale = colorScaleNegative[i];
                    %>
                    <td  style="background-color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);"
                         width="4px" height="6px"></td>
                    <%
                        }
                    %>
                    <%                 colorScale = Color.WHITE;
                        for (int i = colorScalePositive.length - 1; i >= 0; --i) {
                            colorScale = colorScalePositive[i];
                    %>
                    <td  style="background-color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);"
                         width="3px" height="6px"></td>
                    <%
                        }
                    %>
                    <td>+</td>
                </tr>
            </table>
            <br>
        </td>
    </tr>
</table>
<br><br><br>
<br>
<br>
<table style="margin:0 auto; margin:auto; border-color: black; opacity:0.7; " >
    <tr>
        <td></td>
        <td></td>
        <%for (int z = 0; z < indices.length; z++) {
                Color backGroundLetterColor = colorScaleBackground[listTimeIntervalsData.get(indices[z]).getIndexColorCluster()];
                String fontLetterColor = utils.Util.getColorByLuminance(backGroundLetterColor);%>
        <td style="background-color: rgb(<%out.print(backGroundLetterColor.getRed());%>,<%out.print(backGroundLetterColor.getGreen());%>,<%out.print(backGroundLetterColor.getBlue());%>);
            max-width: <%=sizeCell%>px;  min-width: <%=sizeCell%>px; font-size: 10px;" >
            <div style="
                 /* Rotate div */
                 -ms-transform: rotate(-90deg); /* IE 9 */
                 -webkit-transform: rotate(-90deg); /* Chrome, Safari, Opera */
                 transform: rotate(-90deg);    transform-origin: left top ; text-align: left;  ">
                <%out.print(listTimeIntervalsData.get(indices[z]).getNameAttribute());%></div>

        </td>
        <%}%>
    </tr>
    <%for (int i = 0; i < matrixColorCorrelationSubset.length; i++) {
            Color backGroundLetterColor = colorScaleBackground[listTimeIntervalsData.get(indices[i]).getIndexColorCluster()];
    %>

    <tr>
        <td >
            <%out.print(listTimeIntervalsData.get(indices[i]).getNameAttribute());%><br>

        </td>
        <td  style="background-color: rgb(<%out.print(backGroundLetterColor.getRed());%>,<%out.print(backGroundLetterColor.getGreen());%>,<%out.print(backGroundLetterColor.getBlue());%>);
             width: 18px;" 
             ></td>
        <%for (int j = 0; j < matrixColorCorrelationSubset[i].length; j++) {
                if (matrixColorCorrelationSubset[i][j] > 255.0) {
                    matrixColorCorrelationSubset[i][j] = 255;
                }

                double valueCell = matrixColorCorrelationSubset[i][j] / 255.0;
                Color colorCell = null;
                int matrixColorCorrelationValue = matrixColorCorrelationSubset[i][j];

                 if (matrixColorCorrelationValue >= 0) {
                    colorCell = colorScalePositive[255 - matrixColorCorrelationSubset[i][j]];
                } else {
                    colorCell = colorScaleNegative[matrixColorCorrelationSubset[i][j] * -1];
                }
                int red = colorCell.getRed();
                int green = colorCell.getGreen();
                int blue = colorCell.getBlue();
        %>

        <td title="<%out.print(valueCell + "\n" + listTimeIntervalsData.get(indices[i]).getNameAttribute() + " -> " + listTimeIntervalsData.get(indices[j]).getNameAttribute());%>" 
            style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
            color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>);  

            "

            width="<%out.print(sizeCell);%>px" height="<%out.print(sizeCell);%>px">

        </td>

        <%}%>
    </tr>
    <%}%>

</table>