<%-- 
    Document   : index
    Created on : Feb 15, 2016, 4:19:07 PM
    Author     : aurea
--%>

<%@page import="java.util.Arrays"%>
<%@page import="utils.Operations"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%   ArrayList<TimeInterval> listTimeIntervalsData1 = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    ArrayList<Integer> listSelectedAttributesSubset1 = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
    String selectedAttributes1 = (String) session.getAttribute("selectedAttributes");
    String[] selectedAttributesArray1 = selectedAttributes1.split(",");
    Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");

    Float maxY = (Float) session.getAttribute("maxY");
    Float minY = (Float) session.getAttribute("minY");
    Float maxX = (Float) session.getAttribute("maxX");
    Float minX = (Float) session.getAttribute("minX");

    AbstractMatrix projectedMatrix = (AbstractMatrix) session.getAttribute("projectedMatrix");
    String datasetProjectionSubset = "[";

    for (int j = 0; j < listSelectedAttributesSubset1.size(); j++) {

        int indexAttribute = listSelectedAttributesSubset1.get(j); 
        int valueX = Math.round(Operations.minmax(projectedMatrix.getRow(indexAttribute).getValue(0), minX, maxX, 50.f, 1400.f));
        int valueY = Math.round(Operations.minmax(projectedMatrix.getRow(indexAttribute).getValue(1), minY, maxY, 20.f, 560.f));
  

        int indexColorBackground = listTimeIntervalsData1.get(indexAttribute).getIndexColorCluster();
        Color colorBackground;
        if (indexColorBackground == -1) {
            colorBackground = Color.GRAY.brighter();
        } else {
            colorBackground = colorScaleBackground[indexColorBackground];
        }
        datasetProjectionSubset += "{\'x\':" + valueX + ", \'y\':" + valueY + ",\'color\':\'" + Integer.toHexString(colorBackground.getRGB()).substring(2) + "\', \'name\':\'" +"#"+(listTimeIntervalsData1.get(indexAttribute).getCluster()+1)+"-"+listTimeIntervalsData1.get(indexAttribute).getNameAttribute() + "\'},";

    }
    if (datasetProjectionSubset.endsWith(",")) {
        datasetProjectionSubset = datasetProjectionSubset.substring(0, datasetProjectionSubset.length() - 1);
    }

    datasetProjectionSubset += "]";

    //projection.
%>    

<br>
<table style="width: 1500px;height: 580px; margin:0 auto; margin:auto; border-color: black; " border="2">
    <tr>
        <td style="width: 1500px;height:580px; text-align: center; ">
            <div id="generalProjectionContent">  
                <script type="text/javascript"> createCGVisGeneralProjectionSubSet("generalProjectionContent", "1500", "580", "<%=datasetProjectionSubset%>");</script> 
            </div>
        </td>
    </tr>
</table>

