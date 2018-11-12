<%-- 
    Document   : CorrelationMatrix
    Created on : Mar 10, 2016, 3:21:20 PM
    Author     : aurea
--%>
<%@page import="utils.Util"%>
<%@page import="color.BTC"%>
<%@page import="color.HeatedObject"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (listTimeIntervalsData != null) {
        // ArrayList<Integer> listOrderedIds = (ArrayList<Integer>) session.getAttribute("listOrderedIds");
        // int[] listMedoids = (int[]) session.getAttribute("listMedoids");
        //int[][] matrixColorCorrelation = (int[][]) session.getAttribute("matrixColorCorrelation");

        ArrayList<ArrayList<Integer>> resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
        ArrayList<Integer> listOrderedIds = new ArrayList<Integer>();

        for (int elemCluster= 0; elemCluster < resultClustering.size(); elemCluster++) {
            for (int elemMember = 0; elemMember < resultClustering.get(elemCluster).size(); elemMember++) {
                listOrderedIds.add(resultClustering.get(elemCluster).get(elemMember));
            }

        }

        //Matrix Correlation
        int[][] matrixColorCorrelation = Util.calculateColorCorrelationMatrix(listTimeIntervalsData, listOrderedIds);

        Color[] colorScalePositive = (new HeatedObject()).getColorScale();
        Color[] colorScaleNegative = (new BTC()).getColorScale();
        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
        double sizeCell = (1100) / matrixColorCorrelation.length;
        if (matrixColorCorrelation.length > 1100) {
            sizeCell = 1;
        }
%>
<div id="dialog-form"  title="Add or remove attribute:" hidden>
    <input type="radio" id="RadioCorrelationClusterAttribute1" name="RadioCorrelationClusterAttribute" ><label id="LabelCorrelationClusterAttribute1" ></label> <br>
    <input type="radio" id="RadioCorrelationClusterAttribute2" name="RadioCorrelationClusterAttribute" > <label id="LabelCorrelationClusterAttribute2" ></label><br>
</div>
<br>


<table  style="margin:0 auto; margin:auto; ">
    <tr>
        <td  colspan="2">
            <table border="0" style=" text-align: center; background-color:  #ffffff;  margin:0 auto; margin:auto;" >
                <tr>
                    <td>-</td>
                    <%                Color colorScale = Color.WHITE;
                        for (int i = 0; i < colorScaleNegative.length; ++i) {
                            colorScale = colorScaleNegative[i];
                    %>
                    <td  style="background-color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);"
                         width="2px" height="6px"></td>
                    <%
                        }
                    %>
                    <%                 colorScale = Color.WHITE;
                        for (int i = colorScalePositive.length - 1; i >= 0; --i) {
                            colorScale = colorScalePositive[i];
                    %>
                    <td  style="background-color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);color: rgb(<%out.print(colorScale.getRed());%>,<%out.print(colorScale.getGreen());%>,<%out.print(colorScale.getBlue());%>);"
                         width="2px" height="6px"></td>
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
        <td   ></td>
        <td   ></td>
        <%for (int z = 0; z < listOrderedIds.size(); z++) {
         %>
        <td style="max-width: <%=sizeCell%>px;  min-width: <%=sizeCell%>px; font-size: 6px;" >
            <div style="
                 /* Rotate div */
                 -ms-transform: rotate(-90deg); /* IE 9 */
                 -webkit-transform: rotate(-90deg); /* Chrome, Safari, Opera */
                 transform: rotate(-90deg);   transform-origin: left top ;  text-align: left;  ">
                <%out.print(listTimeIntervalsData.get(listOrderedIds.get(z)).getNameAttribute() + "- "+ listTimeIntervalsData.get(listOrderedIds.get(z)).getNameSource()+" " + listTimeIntervalsData.get(listOrderedIds.get(z)).getValueSource());%></div>


        </td>
        <%}%>
    </tr>
      <tr>
        <td   ></td>
        <td   ></td>
        <%for (int z = 0; z < listOrderedIds.size(); z++) {
                Color backGroundLetterColor = colorScaleBackground[listTimeIntervalsData.get(listOrderedIds.get(z)).getIndexColorCluster()];
                String fontLetterColor = utils.Util.getColorByLuminance(backGroundLetterColor);
        %>
        <td style="background-color: rgb(<%out.print(backGroundLetterColor.getRed());%>,<%out.print(backGroundLetterColor.getGreen());%>,<%out.print(backGroundLetterColor.getBlue());%>);"
         width="<%out.print(sizeCell);%>px" height="<%out.print(sizeCell);%>px" >
            
        </td>
        <%}%>
    </tr>
    <%for (int i = 0; i < matrixColorCorrelation.length; i++) {
            Color backGroundLetterColor = colorScaleBackground[listTimeIntervalsData.get(listOrderedIds.get(i)).getIndexColorCluster()];

    %>

    <tr>
        <td   style=" font-size: 12px;text-align: right;">
            <%out.print(listTimeIntervalsData.get(listOrderedIds.get(i)).getNameAttribute() + " - "+ 
                    listTimeIntervalsData.get(listOrderedIds.get(i)).getNameSource()+ " "+ 
        listTimeIntervalsData.get(listOrderedIds.get(i)).getValueSource());%>

        </td>
        <td  style="background-color: rgb(<%out.print(backGroundLetterColor.getRed());%>,<%out.print(backGroundLetterColor.getGreen());%>,<%out.print(backGroundLetterColor.getBlue());%>);"
            width="<%out.print(sizeCell);%>px" height="<%out.print(sizeCell);%>px"
             ></td>
        <%for (int j = 0; j < matrixColorCorrelation[i].length; j++) {
                if (matrixColorCorrelation[i][j] > 255.0) {
                    matrixColorCorrelation[i][j] = 255;
                }
                double valueCell = matrixColorCorrelation[i][j] / 255.0;
                Color colorCell = null;

                if (matrixColorCorrelation[i][j] >= 0) {
                    colorCell = colorScalePositive[255 - matrixColorCorrelation[i][j]];
                } else {
                    colorCell = colorScaleNegative[255 + matrixColorCorrelation[i][j]];
                }
                int red = colorCell.getRed();
                int green = colorCell.getGreen();
                int blue = colorCell.getBlue();
        %>

        <td title="<%out.print(valueCell + "\n" + listTimeIntervalsData.get(listOrderedIds.get(i)).getNameAttribute() + " -> " + listTimeIntervalsData.get(listOrderedIds.get(j)).getNameAttribute());%>" 
            style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
            color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>);  
            "
            width="<%out.print(sizeCell);%>px" height="<%out.print(sizeCell);%>px" ondblclick="messageAddRemoveAttributeCluster('<%=listTimeIntervalsData.get(listOrderedIds.get(i)).getNameAttribute() + " - "+
                    listTimeIntervalsData.get(listOrderedIds.get(i)).getNameSource()+" "+ listTimeIntervalsData.get(listOrderedIds.get(i)).getValueSource()%>', '<%=listTimeIntervalsData.get(listOrderedIds.get(j)).getNameAttribute() + " - "+ listTimeIntervalsData.get(listOrderedIds.get(j)).getNameSource()+" "+ listTimeIntervalsData.get(listOrderedIds.get(j)).getValueSource()%>',
                            '<%=listOrderedIds.get(i)%>', '<%=listOrderedIds.get(j)%>');">

        </td>

        <%}%>
    </tr>
    <%}%>

</table>

<%}%>