<%-- 
    Document   : index
    Created on : Feb 15, 2016, 4:19:07 PM
    Author     : aurea
--%>

<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.awt.Color"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (listTimeIntervalsData != null) {
        ArrayList<ArrayList<Integer>> resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
        int[] listMedoids = (int[]) session.getAttribute("listMedoids");
        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
        Color[] colorScaleCell = (Color[]) session.getAttribute("colorScaleCell");
        //ArrayList<String> stringNodes = (ArrayList<String>) session.getAttribute("stringNodes");
        //ArrayList<String> stringLinks = (ArrayList<String>) session.getAttribute("stringLinks");
        ArrayList<String> stringNodes = new ArrayList<String>();
        ArrayList<String> stringLinks = new ArrayList<String>();

        ArrayList<Integer> listOrderedIds = new ArrayList<Integer>();

        for (int clus = 0; clus < resultClustering.size(); clus++) {
            String stringNode = "[";
            String stringLink = "[";
            if (resultClustering.get(clus).size() == 0) {

            } else {

                if (listMedoids[clus] != -1) {

                    stringNode += "{\'name\':\'" + listTimeIntervalsData.get(listMedoids[clus]).getNameAttribute() + "- Sat." + listTimeIntervalsData.get(listMedoids[clus]).getSatelliteName() + "-" + listTimeIntervalsData.get(listMedoids[clus]).getInitHour() + ":00-" + listTimeIntervalsData.get(listMedoids[clus]).getEndHour() + ":00" + "\',\'group\': 1,\'id\':" + listMedoids[clus] + "}";

                    if (resultClustering.get(clus).size() > 1) {
                        stringNode += ",";
                    }
                    int countElemClus = 1;
                    for (int elemClus = 0; elemClus < resultClustering.get(clus).size(); elemClus++) {
                        listOrderedIds.add(resultClustering.get(clus).get(elemClus));
                        int indexTmpElemClus = resultClustering.get(clus).get(elemClus);
                        if (indexTmpElemClus != listMedoids[clus]) {
                            stringNode += "{\'name\':\'" + listTimeIntervalsData.get(indexTmpElemClus).getNameAttribute() + "- Sat." + listTimeIntervalsData.get(indexTmpElemClus).getSatelliteName() + "-" + listTimeIntervalsData.get(indexTmpElemClus).getInitHour() + ":00-" + listTimeIntervalsData.get(indexTmpElemClus).getEndHour() + ":00" + "\',\'group\': 2,\'id\':" + indexTmpElemClus + "},";
                            stringLink += "{\'source\': " + countElemClus + ", \'target\': 0, \'value\':1},";
                            countElemClus++;
                        }

                    }

                    if (stringNode.endsWith(",")) {
                        stringNode = stringNode.substring(0, stringNode.length() - 1);
                    }
                    if (stringLink.endsWith(",")) {
                        stringLink = stringLink.substring(0, stringLink.length() - 1);
                    }
                }

            }
            stringNode += "]";
            stringLink += "]";
            stringNodes.add(stringNode);
            stringLinks.add(stringLink);
        }

        int numberCols = 0;
        if (resultClustering.size() > 3) {
            numberCols = 3;
        } else {
            numberCols = resultClustering.size();
        }
        int numberRows = resultClustering.size() / 3;
        if (resultClustering.size() % 3 > 0) {
            numberRows++;
        }
        // int totalWidth = 1600;
        // int localWidth = totalWidth / numberCols;

%>
<br>
<table style="width: 1500px; margin:0 auto; margin:auto;   " >
    <%        int countClusters = 1;
        for (int i = 0; i < numberRows && countClusters <= resultClustering.size(); i++) {%>
    <tr>
        <% for (int j = 0; j < numberCols && countClusters <= resultClustering.size(); j++) {
                if (resultClustering.get(countClusters - 1).size() == 0) {
                    countClusters++;

                    if(countClusters>resultClustering.size())
                    {
                        break;
                    }
                }
                int indexMedoid = listMedoids[countClusters - 1];
                int indexColorBackground = listTimeIntervalsData.get(indexMedoid).getIndexColorCluster();
                Color colorBackground = colorScaleBackground[indexColorBackground];
                String fontColor = utils.Util.getColorByLuminance(colorBackground);
                String hexaColor = '#' + Integer.toHexString(colorBackground.getRGB()).substring(2);

        %>


        <td style="width: 500px;height: 500px; text-align: center; ">
            <table style="text-align: center; margin:0 auto; margin:auto;">
                <tr  style="background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>);">
                    <th  style="font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;"  >Cluster <%out.print(countClusters);%></th>
                </tr>
                <tr>

                    <td style="width: 500px; height: 480px;border-style:solid;" >

                        <div id="clusterPlot<%=countClusters%>">  
                            <!--%out.print(resultClustering.get(countClusters-1).size());%-->
                            <script type="text/javascript"> createCGVisSpring("clusterPlot<%=countClusters%>", "480", "<%=(stringNodes.get(countClusters - 1))%>", "<%=(stringLinks.get(countClusters - 1))%>", "<%=hexaColor%>");</script> 

                        </div>
                    </td>


                </tr>
            </table>

        </td>
        <%
                countClusters++;
            }%>
    </tr>
    <%}%>
</table>




<%}%>