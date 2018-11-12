<%-- 
    Document   : UpdateClusterIntervalMatrix
    Created on : Apr 25, 2016, 4:03:37 PM
    Author     : aurea
--%>
<%@page import="distance.EuclideanSimilarity"%>
<%@page import="java.awt.Color"%>
<%@page import="color.AureaComplete"%>
<%@page import="utils.ColorScale"%>
<%@page import="utils.ColorScale"%>
<%@page import="utils.Util"%>
<%@page import="org.apache.catalina.tribes.util.Arrays"%>
<%@page import="clustering.SilhouetteCoefficient"%>
<%@page import="matrix.pointsmatrix.DenseMatrix"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>

<%    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");

    if (listTimeIntervalsData != null) {
        ArrayList<ArrayList<Integer>> resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
        ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
        AbstractMatrix abstractMatrix = (DenseMatrix) session.getAttribute("abstractMatrix");
        float averageSilhouetteCoefficient = 0.f;

        int[] listMedoids = (int[]) session.getAttribute("listMedoids");

        String listIdIntervalString = request.getParameter("listIdInterval");
        String listOldClusterString = request.getParameter("listOldCluster");
        String listNewClusterString = request.getParameter("listNewCluster");

        String listIdIntervalArray[] = listIdIntervalString.split(",");
        String listOldClusterArray[] = listOldClusterString.split(",");
        String listNewClusterArray[] = listNewClusterString.split(",");
        ArrayList<Integer> listPreviousRandomNumbers = new ArrayList<Integer>();
        listPreviousRandomNumbers.add(0);
        int newClusterColor = 0;
        ColorScale backgroundScale = new AureaComplete();
        Color[] colorScaleBackground = backgroundScale.getColorScale();
        if (Util.contains(listNewClusterArray, "+1")) {
            resultClustering.add(new ArrayList<Integer>());
            listMedoids = (int[]) Util.resizeArray(listMedoids, listMedoids.length + 1);
            newClusterColor = Util.randomColor(listPreviousRandomNumbers, colorScaleBackground);
        }

        for (int i = 0; i < listIdIntervalArray.length; i++) {
            Integer index = Integer.valueOf(listIdIntervalArray[i]);
            Integer oldCluster = Integer.valueOf(listOldClusterArray[i]);
            String newCluster = listNewClusterArray[i];

            // modyfing list clusters
            int indexOldCluster = resultClustering.get(oldCluster - 1).indexOf(index);
            resultClustering.get(oldCluster - 1).remove(indexOldCluster);

            if (newCluster.equals("+1")) {

                resultClustering.get(resultClustering.size() - 1).add(index);
                listMedoids[resultClustering.size() - 1] = index;
            } else {
                resultClustering.get(Integer.valueOf(newCluster) - 1).add(index);
            }

            // modyfing medoids and subset of attr.
            if (listMedoids[oldCluster - 1] == index) {
                if (resultClustering.get(oldCluster - 1).size() > 0) {
                    listMedoids[oldCluster - 1] = resultClustering.get(oldCluster - 1).get(0);
                    if (selectedAttributesSubset.contains(index)) {
                        int indexTmp = selectedAttributesSubset.indexOf(index);
                        selectedAttributesSubset.remove(indexTmp);
                        selectedAttributesSubset.add(listMedoids[oldCluster - 1]);

                    }
                } else {
                    listMedoids[oldCluster - 1] = -1;
                    if (selectedAttributesSubset.contains(index)) {
                        int indexTmp = selectedAttributesSubset.indexOf(index);
                        selectedAttributesSubset.remove(indexTmp);

                    }
                }

            }

            //updating cluster time interval
            if (newCluster.equals("+1")) {
                listTimeIntervalsData.get(index).setCluster(resultClustering.size());

                listTimeIntervalsData.get(index).setIndexColorCluster(newClusterColor);
                abstractMatrix.getRow(index).setKlass(resultClustering.size());
            } else {
                listTimeIntervalsData.get(index).setCluster(Integer.valueOf(newCluster));
                int newIndexColor = listTimeIntervalsData.get(resultClustering.get(Integer.valueOf(newCluster) - 1).get(0)).getIndexColorCluster();
                listTimeIntervalsData.get(index).setIndexColorCluster(newIndexColor);
                abstractMatrix.getRow(index).setKlass(Integer.valueOf(newCluster));
            }

        }

        ArrayList<Integer> listNullCluster = new ArrayList<Integer>();
        for (int i = 0; i < resultClustering.size(); i++) {
            if (resultClustering.get(i).isEmpty()) {
                listNullCluster.add(i);
            }
        }

        for (int i = 0; i < listNullCluster.size(); i++) {
            for (int itmCluster = listNullCluster.get(i) + 1; itmCluster < resultClustering.size(); itmCluster++) {
                for (int itmMember = 0; itmMember < resultClustering.get(itmCluster).size(); itmMember++) {
                    int index = resultClustering.get(itmCluster).get(itmMember);
                    listTimeIntervalsData.get(index).setCluster(itmCluster);
                    abstractMatrix.getRow(index).setKlass(itmCluster);
                }
            }
            resultClustering = utils.Util.removeIntegerArrayListMatrix(listNullCluster.get(i), resultClustering);
            listMedoids = utils.Util.removeIntegerArray(listNullCluster.get(i), listMedoids);

        }

        SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
        float[] silhouetteCoefficients = silhouetteCoefficient.execute(abstractMatrix, new EuclideanSimilarity());
        averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
        averageSilhouetteCoefficient = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;

        session.setAttribute("listTimeIntervalsData", listTimeIntervalsData);
        session.setAttribute("resultClustering", resultClustering);
        session.setAttribute("listMedoids", listMedoids);
        session.setAttribute("listSelectedAttributesSubset", selectedAttributesSubset);
        session.setAttribute("abstractMatrix", abstractMatrix);

        session.setAttribute("averageSilhouetteCoefficient", averageSilhouetteCoefficient);


%>

<table style="text-align: center; margin:0 auto; margin:auto; width:800px;">
    <tr>

        <td style="width:50%; text-align: right; "> 
            <b>Clustering Evaluation:</b>
        </td>
        <td style="width:50%;  "> 
            <input style="width:135px" id="clusteringEvaluationText" name="clusteringEvaluationText" type="text" disabled
                   value="<%=averageSilhouetteCoefficient%>"
                   >

        </td>

    </tr>
    <tr>

        <td colspan="2"> 
            Successfully updated.
        </td>

    </tr>
</table>
<%}%>