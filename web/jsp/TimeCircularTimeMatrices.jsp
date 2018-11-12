<%-- 
    Document   : attributesImageTable
    Created on : Jan 11, 2016, 4:07:09 PM
    Author     : aurea
--%>



<%@page import="distance.PearsonCorrelation"%>
<%@page import="distance.ManhattanSimilarity"%>
<%@page import="distance.Euclidean"%>
<%@page import="dataMaker.TimeCircular"%>
<%@page import="matrix.pointsmatrix.AbstractVector"%>
<%@page import="trees.clusteringtree.ClusteringTree"%>
<%@page import="distance.L1Norm"%>
<%@page import="distance.AbstractDissimilarity"%>
<%@page import="distance.EuclideanSimilarity"%>
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
<%@page import="categorization.CategorizationObject"%>
<script type='text/javascript'>
    var listIdInterval = [];
    var listNewCluster = [];
    var listOldCluster = [];</script>


<%
    ArrayList<TimeInterval> listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    String optionClustering = (String) request.getParameter("optionClustering");
    String haarLevelRangeStr = (String) request.getParameter("haarLevelRangeStr");
    String corrCoeffStr = (String) request.getParameter("corrCoeffStr");
    int haarLevelRange = 0;
    if (haarLevelRangeStr != null) {
        haarLevelRange = Integer.valueOf(haarLevelRangeStr);
    } else {
        Integer haarLevelRangeSession = (Integer) session.getAttribute("haarLevelRange");
        if (haarLevelRangeSession != null) {
            haarLevelRange = haarLevelRangeSession;
        }
    }
    double corrCoeff = 0.8;
    if (corrCoeffStr != null) {
        corrCoeff = Double.valueOf(corrCoeffStr);
    } else {
        Double corrCoeffSession = (Double) session.getAttribute("corrCoeff");
        if (corrCoeffSession != null) {
            corrCoeff = corrCoeffSession;
        }
    }

    String aggregationFunction = (String) session.getAttribute("aggregationFunction");
    String valueUnitTimeInterval = (String) session.getAttribute("valueUnitTimeInterval");
    String unitTimeInterval = (String) session.getAttribute("unitTimeInterval");
    if (listTimeIntervalsData != null) {
        int maxHaarLevelRange = 0;
        String subGroupSizeStr = (String) request.getParameter("subGroupSizeStr");
        int subGroupSize = listTimeIntervalsData.get(0).getMatrix().getCols();
        if (subGroupSizeStr != null && subGroupSizeStr != "") {
            subGroupSize = Integer.valueOf(subGroupSizeStr);
        } else {
            Integer subGroupSizeSession = (Integer) session.getAttribute("subGroupSize");
            if (subGroupSizeSession != null) {
                subGroupSize = subGroupSizeSession;
            }
        }
        maxHaarLevelRange = utils.Util.calculateMaxHaarLevel(subGroupSize);

        //AbstractDissimilarity abstractDissimilarity = new L1Norm();//new EuclideanSimilarity();
        AbstractDissimilarity dissimilarity = new Euclidean();
        String selectedSimilarity = (String) session.getAttribute("selectedSimilarity");
        if (selectedSimilarity == null) {
            selectedSimilarity = "Euclidean";
        }

        if (selectedSimilarity.equals("Euclidean")) {
            dissimilarity = new Euclidean();
        } else {
            if (selectedSimilarity.equals("Manhattan")) {
                dissimilarity = new ManhattanSimilarity();
            } else {
                if (selectedSimilarity.equals("Pearson")) {
                    dissimilarity = new PearsonCorrelation();

                } else {
                    dissimilarity = new Euclidean();
                }
            }
        }
        ArrayList<ArrayList<String>> listAttributes = (ArrayList<ArrayList<String>>) session.getAttribute("listAttributes");
        ArrayList<CategorizationObject> listCategorization = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
        Integer hierarchicalLevelRange = 0;
        ArrayList<ArrayList<Integer>> resultClustering = null;
        ArrayList<Integer> listSelectedAttributesSubset = null;
        Float averageSilhouetteCoefficient = 0.f;
        String clustering = "";

        AbstractMatrix abstractMatrix = (DenseMatrix) session.getAttribute("abstractMatrix");
        String datasetProjection = "";
        Integer numberMaxGroup = listTimeIntervalsData.size();

        //Color Style Checkbox
        String colorStyleRadioButton = (String) request.getParameter("colorStyleRadioButton");
        ArrayList<String> filteredSource1Categories = new ArrayList<String>();
        ArrayList<Integer> filteredSource1CategoriesColors = new ArrayList<Integer>();

        if (colorStyleRadioButton != null) {
            resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
            listSelectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
            clustering = (String) session.getAttribute("clustering");
            if (colorStyleRadioButton.equals("category")) {
                AbstractMatrix projectedMatrix = (AbstractMatrix) session.getAttribute("projectedMatrix");

                AbstractMatrix abstractMatrixPrevious = new DenseMatrix();
                AbstractMatrix projectedMatrixPrevious = new DenseMatrix();

                abstractMatrixPrevious.setAttributes((ArrayList<String>) abstractMatrix.getAttributes().clone());
                projectedMatrixPrevious.setAttributes((ArrayList<String>) projectedMatrix.getAttributes().clone());
                abstractMatrixPrevious.setLabels((ArrayList<String>) abstractMatrix.getLabels().clone());
                projectedMatrixPrevious.setLabels((ArrayList<String>) projectedMatrix.getLabels().clone());

                ArrayList<TimeInterval> listTimeIntervalsDataPrevious = new ArrayList<TimeInterval>();

                ClusteringTree clusteringTree = (ClusteringTree) session.getAttribute("clusteringTree");
                session.setAttribute("clusteringTree2", clusteringTree);

                float averageSilhouetteCoefficientPrevious = (float) session.getAttribute("averageSilhouetteCoefficient");
                session.setAttribute("averageSilhouetteCoefficient2", averageSilhouetteCoefficientPrevious);

                ArrayList<TimeInterval> listTimeIntervalsDataCategory = new ArrayList<TimeInterval>();
                AbstractMatrix abstractMatrixCategory = new DenseMatrix();
                AbstractMatrix projectedMatrixCategory = new DenseMatrix();

                abstractMatrixCategory.setAttributes((ArrayList<String>) abstractMatrix.getAttributes().clone());
                projectedMatrixCategory.setAttributes((ArrayList<String>) projectedMatrixCategory.getAttributes().clone());
                abstractMatrixCategory.setLabels((ArrayList<String>) abstractMatrix.getLabels().clone());
                projectedMatrixCategory.setLabels((ArrayList<String>) projectedMatrixCategory.getLabels().clone());

                ArrayList<String> listSource1Category = (ArrayList<String>) session.getAttribute("listSource1Category");
                ArrayList<ArrayList<String>> listSource1 = (ArrayList<ArrayList<String>>) session.getAttribute("listSource1");

                filteredSource1Categories = new ArrayList<String>();
                filteredSource1CategoriesColors = new ArrayList<Integer>();

                hierarchicalLevelRange = 0;

                // color 
                ColorScale backgroundScale = new AureaComplete();
                Color[] colorScaleBackground = backgroundScale.getColorScale();
                ArrayList<Integer> listPreviousRandomNumbersCategory = new ArrayList<Integer>();

                listPreviousRandomNumbersCategory.add(0);
                int indexColorCategory = 0;
                for (int countCategory = 0; countCategory < listSource1Category.size(); countCategory++) {
                    indexColorCategory = utils.Util.randomColor(listPreviousRandomNumbersCategory, colorScaleBackground);
                    listPreviousRandomNumbersCategory.add(indexColorCategory);
                }

                for (int countTimeIntervals = 0; countTimeIntervals < listTimeIntervalsData.size(); countTimeIntervals++) {
                    String source1Id = listTimeIntervalsData.get(countTimeIntervals).getIdSource();

                    for (int countCategories = 0; countCategories < listSource1Category.size(); countCategories++) {

                        if (listSource1.get(countCategories).contains(source1Id)) {
                            AbstractVector originalVector = (AbstractVector) abstractMatrix.getRow(countTimeIntervals).clone();
                            AbstractVector projectedVector = (AbstractVector) projectedMatrix.getRow(countTimeIntervals).clone();

                            AbstractVector originalVectorPrevious = (AbstractVector) abstractMatrix.getRow(countTimeIntervals).clone();
                            AbstractVector projectedVectorPrevious = (AbstractVector) projectedMatrix.getRow(countTimeIntervals).clone();

                            abstractMatrixPrevious.addRow(originalVectorPrevious, abstractMatrix.getLabel(countTimeIntervals));
                            projectedMatrixPrevious.addRow(projectedVectorPrevious, projectedMatrix.getLabel(countTimeIntervals));

                            originalVector.setKlass(countCategories + 1);
                            projectedVector.setKlass(countCategories + 1);

                            abstractMatrixCategory.addRow(originalVector, abstractMatrix.getLabel(countTimeIntervals));
                            projectedMatrixCategory.addRow(projectedVector, projectedMatrix.getLabel(countTimeIntervals));

                            TimeInterval timeMatrix = (TimeInterval) listTimeIntervalsData.get(countTimeIntervals).clone();
                            TimeInterval timeMatrixPrevious = (TimeInterval) listTimeIntervalsData.get(countTimeIntervals).clone();

                            timeMatrix.setCluster(countCategories + 1);
                            timeMatrix.setIndexColorCluster(listPreviousRandomNumbersCategory.get(countCategories));

                            listTimeIntervalsDataPrevious.add(timeMatrixPrevious);
                            listTimeIntervalsDataCategory.add(timeMatrix);
                            if (!filteredSource1Categories.contains(listSource1Category.get(countCategories))) {
                                filteredSource1Categories.add(listSource1Category.get(countCategories));
                                filteredSource1CategoriesColors.add(listPreviousRandomNumbersCategory.get(countCategories));
                            }
                            countCategories = listSource1Category.size();
                        }
                    }
                }

                session.setAttribute("abstractMatrix2", abstractMatrixPrevious);
                session.setAttribute("projectedMatrix2", projectedMatrixPrevious);
                session.setAttribute("listTimeIntervalsData2", listTimeIntervalsDataPrevious);

                String datasetProjectionCategory = "";
                KDTree tree = (KDTree) session.getAttribute("tree");
                KDTree treeCategory = (KDTree) tree.clone();
                numberMaxGroup = (Integer) session.getAttribute("numberMaxGroup");

                //measuring the clustering
                Float averageSilhouetteCoefficient2 = 0.f;
                if (filteredSource1Categories.size() > 1) {
                    SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
                    float[] silhouetteCoefficients = silhouetteCoefficient.execute(abstractMatrixCategory, dissimilarity);
                    averageSilhouetteCoefficient2 = silhouetteCoefficient.average(silhouetteCoefficients);
                    averageSilhouetteCoefficient2 = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;
                } else {
                    averageSilhouetteCoefficient2 = 0.f;
                }

                //hierarchicalClustering
                clustering = (String) session.getAttribute("clustering");
                if (clustering == null) {
                    clustering = "Xmeans";
                }
                resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");

                Clustering clusteringMethod = (Clustering) session.getAttribute("clusteringMethod");
                clusteringTree = new ClusteringTree();
                clusteringTree.buildClusteringTree(0, abstractMatrixCategory, "Xmeans", 0, clusteringMethod,
                        resultClustering);

                listTimeIntervalsData = listTimeIntervalsDataCategory;
                abstractMatrix = abstractMatrixCategory;
                averageSilhouetteCoefficient = averageSilhouetteCoefficient2;
                session.setAttribute("clusteringTree", clusteringTree);
                session.setAttribute("currentClusteringNode", null);
                session.setAttribute("listTimeIntervalsData", listTimeIntervalsDataCategory);
                session.setAttribute("abstractMatrix", abstractMatrixCategory);
                session.setAttribute("averageSilhouetteCoefficient", averageSilhouetteCoefficient2);
            } else {

                AbstractMatrix projectedMatrix = (AbstractMatrix) session.getAttribute("projectedMatrix2");
                session.setAttribute("projectedMatrix", projectedMatrix);
                ClusteringTree clusteringTree = (ClusteringTree) session.getAttribute("clusteringTree2");
                session.setAttribute("clusteringTree", clusteringTree);
                listTimeIntervalsData = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData2");
                session.setAttribute("listTimeIntervalsData", listTimeIntervalsData);
                abstractMatrix = (AbstractMatrix) session.getAttribute("abstractMatrix2");
                session.setAttribute("abstractMatrix", abstractMatrix);
                averageSilhouetteCoefficient = (Float) session.getAttribute("averageSilhouetteCoefficient2");
                session.setAttribute("averageSilhouetteCoefficient", averageSilhouetteCoefficient);

            }

        } else {
            if (optionClustering == null) {
                resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
                listSelectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");
                averageSilhouetteCoefficient = (Float) session.getAttribute("averageSilhouetteCoefficient");
                clustering = (String) session.getAttribute("clustering");
            } else {
                if (optionClustering.equals("reclustering")) {
                    int numberClusters = Integer.valueOf(request.getParameter("numberClusters"));
                    clustering = (String) request.getParameter("clustering");

                    Clustering clusteringMethod = null;
                    resultClustering = new ArrayList<ArrayList<Integer>>();

                    int[] listMedoids = null;

                    if (clustering.equals("Xmeans")) {
                        clusteringMethod = new Xmeans(abstractMatrix.getRowCount());
                        resultClustering = clusteringMethod.execute(dissimilarity, abstractMatrix);
                        listMedoids = clusteringMethod.getMedoids(abstractMatrix);
                    } else {
                        if (clustering.equals("Kmeans")) {
                            clusteringMethod = new Kmeans(numberClusters);
                            resultClustering = clusteringMethod.execute(dissimilarity, abstractMatrix);
                            listMedoids = clusteringMethod.getMedoids(abstractMatrix);
                        } else {
                            if (clustering.equals("Kmedoids")) {
                                clusteringMethod = new Kmedoids(numberClusters);
                                resultClustering = clusteringMethod.execute(dissimilarity, abstractMatrix);
                                listMedoids = clusteringMethod.getMedoids(abstractMatrix);
                            } else {

                                if (clustering.equals("BKmeans")) {
                                    clusteringMethod = new BKmeans(numberClusters);
                                    resultClustering = clusteringMethod.execute(dissimilarity, abstractMatrix);
                                    listMedoids = clusteringMethod.getMedoids(abstractMatrix);
                                } else {

                                    if (clustering.equals("BKmedoids")) {
                                        clusteringMethod = new BKmedoids(numberClusters);
                                        resultClustering = clusteringMethod.execute(dissimilarity, abstractMatrix);
                                        listMedoids = clusteringMethod.getMedoids(abstractMatrix);
                                    }
                                }
                            }
                        }
                    }

                    //hierarchicalClustering
                    ClusteringTree clusteringTree = new ClusteringTree();
                    clusteringTree.buildClusteringTree(0, abstractMatrix, "Xmeans", 0, clusteringMethod, resultClustering);

                    //adjustment of colors
                    ColorScale backgroundScale = new AureaComplete();
                    Color[] colorScaleBackground = backgroundScale.getColorScale();
                    ColorScale cellScale = new HeatedObject();
                    Color[] colorScaleCell = cellScale.getColorScale();

                    ArrayList<Integer> listPreviousRandomNumbers = new ArrayList<Integer>();
                    listPreviousRandomNumbers.add(0);
                    int indexColorCluster = 0;

                    for (int countCluster = 0; countCluster < resultClustering.size(); countCluster++) {
                        indexColorCluster = listPreviousRandomNumbers.get(listPreviousRandomNumbers.size() - 1);
                        for (int itemCluster = 0; itemCluster < resultClustering.get(countCluster).size(); itemCluster++) {
                            int indexTmpInterval = resultClustering.get(countCluster).get(itemCluster);
                            listTimeIntervalsData.get(indexTmpInterval).setCluster(countCluster + 1);
                            listTimeIntervalsData.get(indexTmpInterval).setIndexColorCluster(indexColorCluster);

                            //fill clusters in matrix
                            abstractMatrix.getRow(indexTmpInterval).setKlass(countCluster + 1);
                        }
                        indexColorCluster = utils.Util.randomColor(listPreviousRandomNumbers, colorScaleBackground);
                        listPreviousRandomNumbers.add(indexColorCluster);
                    }

                    //measuring the clustering
                    if (resultClustering.size() > 1) {
                        SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
                        float[] silhouetteCoefficients = silhouetteCoefficient.execute(abstractMatrix, dissimilarity);
                        averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
                        averageSilhouetteCoefficient = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;
                    } else {
                        averageSilhouetteCoefficient = 0.f;
                    }

                    //adding first important variables = medois
                    listSelectedAttributesSubset = new ArrayList<Integer>();
                    if (listMedoids != null) {
                        for (int cntMedoids = 0; cntMedoids < listMedoids.length; cntMedoids++) {
                            listSelectedAttributesSubset.add(listMedoids[cntMedoids]);
                        }
                    }

                    session.setAttribute("clusteringTree", clusteringTree);
                    session.setAttribute("currentClusteringNode", null);
                    session.setAttribute("listTimeIntervalsData", listTimeIntervalsData);
                    session.setAttribute("resultClustering", resultClustering);
                    session.setAttribute("listMedoids", listMedoids);
                    session.setAttribute("listSelectedAttributesSubset", listSelectedAttributesSubset);
                    session.setAttribute("listTimeIntervalsData", listTimeIntervalsData);
                    session.setAttribute("abstractMatrix", abstractMatrix);
                    session.setAttribute("clustering", clustering);
                    session.setAttribute("clusteringMethod", clusteringMethod);
                    session.setAttribute("averageSilhouetteCoefficient", averageSilhouetteCoefficient);

                } else {
                    if (optionClustering.equals("updateclusters")) {
                        resultClustering = (ArrayList<ArrayList<Integer>>) session.getAttribute("resultClustering");
                        ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");

                        averageSilhouetteCoefficient = 0.f;

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
                        float[] silhouetteCoefficients = silhouetteCoefficient.execute(abstractMatrix, dissimilarity);
                        averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
                        averageSilhouetteCoefficient = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;
                        listSelectedAttributesSubset = selectedAttributesSubset;

                        //hierarchicalClustering
                        Clustering clusteringMethod = (Clustering) session.getAttribute("clusteringMethod");
                        ClusteringTree clusteringTree = new ClusteringTree();
                        clusteringTree.buildClusteringTree(0, abstractMatrix, "Xmeans", 0, clusteringMethod, resultClustering);

                        session.setAttribute("clusteringTree", clusteringTree);
                        session.setAttribute("currentClusteringNode", null);
                        session.setAttribute("listTimeIntervalsData", listTimeIntervalsData);
                        session.setAttribute("resultClustering", resultClustering);
                        session.setAttribute("listMedoids", listMedoids);
                        session.setAttribute("listSelectedAttributesSubset", selectedAttributesSubset);
                        session.setAttribute("abstractMatrix", abstractMatrix);

                        session.setAttribute("averageSilhouetteCoefficient", averageSilhouetteCoefficient);

                    }
                }
            }
        }
        int numCols = 6;

        if (numCols > listTimeIntervalsData.size()) {
            numCols = listTimeIntervalsData.size();
        }

        int numRows = (int) Math.ceil(listTimeIntervalsData.size() * 1.0 / numCols);

        Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
        Color[] colorScaleCell = (Color[]) session.getAttribute("colorScaleCell");
        int sizeCellWidth = (int) Math.ceil(220 / listTimeIntervalsData.get(0).getMatrix().getCols()) + 3;
        int sizeCellHeight = (int) Math.ceil(160 / listTimeIntervalsData.get(0).getMatrix().getRows()) + 3;

        if (sizeCellWidth < 3) {
            sizeCellWidth = 3;
        }
        if (sizeCellHeight < 3) {
            sizeCellHeight = 3;
        }
        /*if(sizeCellHeight>sizeCellWidth){
sizeCellHeight= sizeCellWidth;
}else
{
           
sizeCellWidth=sizeCellHeight;
}*/

        int sizeTable = sizeCellWidth * listTimeIntervalsData.get(0).getMatrix().getCols() + 10;
        if (sizeTable < 300) {
            sizeTable = 300;
        }

        AbstractMatrix projectedMatrix = null;

        String projection = "";
        projection = request.getParameter("projection");
        if (projection == null) {
            projection = (String) session.getAttribute("projection");
            if (projection == null) {
                projection = "IDMAPProjection";
            }

        } else {
            session.setAttribute("projection", projection);
        }

        if (projection.equals("LSP")) {
            LSPProjection2D lsp = new LSPProjection2D();
            //lsp.setNumberNeighbors(3);
            lsp.setControlPointsChoice(ControlPointsType.KMEANS);
            //lsp.setFractionDelta(4.0f);
            // lsp.setNumberIterations(50);
            lsp.setNumberControlPoints(10);//lsp.setNumberControlPoints(abstractMatrix.getRowCount() / 10);
            projectedMatrix = lsp.project(abstractMatrix, dissimilarity);

        } else {

            if (projection.equals("ProjClusProjection")) {
                ProjClusProjection projectionTechnique2 = new ProjClusProjection();
                projectedMatrix = projectionTechnique2.project(abstractMatrix, dissimilarity);
            } else {

                if (projection.equals("FastMapProjection")) {
                    FastmapProjection projectionTechnique4 = new FastmapProjection();
                    projectedMatrix = projectionTechnique4.project(abstractMatrix, dissimilarity);
                } else {
                    if (projection.equals("ForceSchemeProjection")) {
                        ForceSchemeProjection2D projectionTechnique5 = new ForceSchemeProjection2D();
                        projectedMatrix = projectionTechnique5.project(abstractMatrix, dissimilarity);
                    } else {
                        if (projection.equals("IDMAPProjection")) {
                            IDMAPProjection projectionTechnique6 = new IDMAPProjection();
                            projectedMatrix = projectionTechnique6.project(abstractMatrix, dissimilarity);
                        } else {
                            projectedMatrix = null;
                        }
                    }
                }

            }
        }

        float maxY = Float.MIN_VALUE;
        float minY = Float.MAX_VALUE;
        float maxX = Float.MIN_VALUE;
        float minX = Float.MAX_VALUE;

        ArrayList<Point2D> points = new ArrayList<Point2D>();
        ArrayList<ArrayList<Integer>> labels = new ArrayList<ArrayList<Integer>>();

        if (projectedMatrix != null) {
            for (int i = 0; i < projectedMatrix.getRowCount(); i++) {
                if (maxX < projectedMatrix.getRow(i).getValue(0)) {
                    maxX = projectedMatrix.getRow(i).getValue(0);
                }
                if (maxY < projectedMatrix.getRow(i).getValue(1)) {
                    maxY = projectedMatrix.getRow(i).getValue(1);
                }
                if (minX > projectedMatrix.getRow(i).getValue(0)) {
                    minX = projectedMatrix.getRow(i).getValue(0);
                }
                if (minY > projectedMatrix.getRow(i).getValue(1)) {
                    minY = projectedMatrix.getRow(i).getValue(1);
                }
            }

            for (int i = 0; i < projectedMatrix.getRowCount(); i++) {
                int valueX = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(0), minX, maxX, 40.f, 1050.f));
                int valueY = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(1), minY, maxY, 40.f, 180.f));

                // tree.insert(new Point(valueX, valueY), i);
                int position = points.indexOf(new Point2D(valueX, valueY));
                if (position != -1) {
                    labels.get(position).add(i);
                } else {
                    points.add(new Point2D(valueX, valueY));
                    ArrayList<Integer> subListLabels = new ArrayList<Integer>();
                    subListLabels.add(i);
                    labels.add(subListLabels);

                }

            }

            numberMaxGroup = 0;

            ArrayList<KDData> listData = new ArrayList<KDData>();
            for (int i = 0; i < points.size(); i++) {
                listData.add(new KDData(points.get(i), labels.get(i)));
            }

            KDTree tree = new KDTree();
            tree.buildKDTree(0, listData);

            if (tree.getRoot().getLeft() != null) {

                int maxNumber = 0;
                maxNumber = tree.getNumberSubNodesPointsByLevel(tree.getRoot().getLeft(), 1, maxNumber);
                if (maxNumber > numberMaxGroup) {
                    numberMaxGroup = maxNumber;
                }
            }
            if (tree.getRoot().getRight() != null) {
                int maxNumber = 0;
                maxNumber = tree.getNumberSubNodesPointsByLevel(tree.getRoot().getRight(), 1, maxNumber);
                if (maxNumber > numberMaxGroup) {
                    numberMaxGroup = maxNumber;
                }
            }
            if (numberMaxGroup == 0) {
                numberMaxGroup = listTimeIntervalsData.size();
            }

            hierarchicalLevelRange = 1;
            datasetProjection = tree.getD3VariableSubNodesByLevel(tree.getRoot(), 1, listTimeIntervalsData, colorScaleBackground);

            session.setAttribute("haarLevelRange", haarLevelRange);
            session.setAttribute("corrCoeff", corrCoeff);
            session.setAttribute("subGroupSize", subGroupSize);
            session.setAttribute("projection", projection);
            session.setAttribute("projectedMatrix", projectedMatrix);
            session.setAttribute("datasetProjection", datasetProjection);
            session.setAttribute("maxY", maxY);
            session.setAttribute("minY", minY);
            session.setAttribute("maxX", maxX);
            session.setAttribute("minX", minX);
            session.setAttribute("tree", tree);
            session.setAttribute("currentNode", tree.getRoot());
            session.setAttribute("currentLevel", 1);
            session.setAttribute("numberMaxGroup", numberMaxGroup);
        }
        //Color[] colorScaleBorder = (new BTC()).getColorScale();
%>
<style type="text/css">

    path.arc {
        cursor: move;
        fill: #fff;
    }

    .node {
        font-size: 10px;
    }

    .node:hover {
        fill: #1f77b4;
    }

    .link {
        fill: none;
        stroke: #1f77b4;
        stroke-opacity: .4;
        pointer-events: none;
    }

    .link.source, .link.target {
        stroke-opacity: 1;
        stroke-width: 2px;
    }

    .node.target {
        fill: #d62728 !important;
    }

    .link.source {
        stroke: #d62728;
    }

    .node.source {
        fill: #2ca02c;
    }

    .link.target {
        stroke: #2ca02c;
    }

    .node:hover,
    .node--source,
    .node--target {
        font-weight: 700;
    }

    .node--source {
        fill: #2ca02c;
    }

    .node--target {
        fill: #d62728;
    }

    .link--source,
    .link--target {
        stroke-opacity: 1;
        stroke-width: 2px;
    }

    .link--source {
        stroke: #d62728;
    }

    .link--target {
        stroke: #2ca02c;
    }

    div.tooltip {	
        position: absolute;			
        text-align: center;			
        width: 300px;					
        height: 20px;					
        padding: 2px;				
        font: 12px sans-serif;		
        background: lightsteelblue;	
        border: 0px;		
        border-radius: 8px;		
    }
</style>
<div id="previousAttributeClick">
    <input hidden="hidden" id="idPreviousAttribute" value="" >
    <input  hidden="hidden"id="borderColorPreviousAttribute" value="" >
    <input  hidden="hidden" id="idPreviousCircleAttribute" value="" >
    <input  hidden="hidden" id="borderColorPreviousCircleAttribute" value="" >
</div>
<div id="AttributeMatricesContent" onclick="repaintPreviousBorderColor();"  ><!--onmousewheel="repaintPreviousBorderColor();" onscroll="repaintPreviousBorderColor();"-->
    <table  id="projectionTable" style="text-align: center; background-color: white;margin:0 auto; margin:auto;  margin-left: 2.7%; z-index: 100;"><!--position: fixed; margin-left: 10%; z-index: 100;-->
        <tr>
            <td >
                <table >
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
                                        onchange="updateHierarchicalProjectionMatrices();" >
                            </div></td>
                    </tr>

                    <tr>
                        <td style="text-align: left;">
                            Fixed:
                            <input type="checkbox" name="blockProjectionVisualizationCheckBox" 
                                   id="blockProjectionVisualizationCheckBox"
                                   onchange="blockProjectionVisualization();">
                        </td>
                    </tr>
                    <tr>
                        <td style="width:1240px;">
                            <div id="generalProjectionContent" >  
                                <script type="text/javascript"> createCGVisGeneralProjectionMatrices("generalProjectionContent",
                                            "1190", "240", "<%=datasetProjection%>", "<%=numberMaxGroup%>");</script> 
                            </div>
                        </td>
                    </tr>


                </table>
            </td>
            <td style="width:340px;">
                <table >
                    <tr><td colspan="2"><b><u> VARIABLE SETTINGS</u></b></td></tr>
                    <tr>
                        <td style="text-align: right; "><b>Projection:</b></td>
                        <td >   <select name="selectProjection" id="selectProjection"    style="width: 135px" 
                                        >
                                <option value="LSP"<%                                                if (projection != null && projection.equals("LSP")) {%>
                                        selected
                                        <%}%>
                                        >LSP - Paulovich</option>
                                <option value="ProjClusProjection"<%
                                    if (projection != null && projection.equals("ProjClusProjection")) {%>
                                        selected
                                        <%}%>
                                        >ProjClusProjection-Paulovich</option>
                                <option value="FastMapProjection" <%
                                    if (projection != null && projection.equals("FastMapProjection")) {%>
                                        selected
                                        <%}
                                        %>>FastMap-Faloutsos</option>
                                <option value="ForceSchemeProjection" <%
                                    if (projection != null && projection.equals("ForceSchemeProjection")) {%>
                                        selected
                                        <%}
                                        %>>Force Scheme-Tejada</option>
                                <option value="IDMAPProjection" <%
                                    if (projection != null && projection.equals("IDMAPProjection")) {%>
                                        selected
                                        <%}
                                        %>>IDMAP -Minghim</option>

                            </select></td>
                    </tr>
                    <tr> <td style="text-align: right; "><b>Color Style:</b></td><td></td></tr>
                    <tr>  
                        <td> <input type="radio" id="colorStyleRadioButton" name="colorStyleRadioButton" value="cluster"
                                    <% if (colorStyleRadioButton != null && colorStyleRadioButton.equals("cluster") || colorStyleRadioButton == null) {%>
                                    checked
                                    <%}%>
                                    onclick="changeColorStyleVariableProjectionTimeCircular();"> Cluster</td>
                        <td> <input type="radio" id="colorStyleRadioButton" name="colorStyleRadioButton" value="category" 
                                    <% if (colorStyleRadioButton != null && colorStyleRadioButton.equals("category")) {%>
                                    checked
                                    <%}%>
                                    onclick="changeColorStyleVariableProjectionTimeCircular();"> Category</td>
                    </tr>
                    <tr>
                        <td style="text-align: right; "><b>Clustering:</b></td>
                        <td >   <select name="selectClustering" id="selectClustering"    style="width: 135px" onchange="filterClusteringSelection();">
                                <option value="Xmeans" <%                        if (clustering != null && clustering.equals("Xmeans")) {%>
                                        selected
                                        <%}
                                        %>>Xmeans</option>
                                <option value="Kmeans"<%                                        if (clustering != null && clustering.equals("Kmeans")) {%>
                                        selected
                                        <%}%>
                                        >Kmeans</option>
                                <option value="BKmeans"<%
                                    if (clustering != null && clustering.equals("BKmeans")) {%>
                                        selected
                                        <%}%>
                                        >BKmeans</option>
                                <option value="Kmedoids"<%
                                    if (clustering != null && clustering.equals("Kmedoids")) {%>
                                        selected
                                        <%}%>
                                        >Kmedoids</option>
                                <option value="BKmedoids"<%
                                    if (clustering != null && clustering.equals("BKmedoids")) {%>
                                        selected
                                        <%}%>
                                        >BKmedoids</option>
                            </select></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; "><b>#Clusters:</b></td>
                        <td  >
                            <select name="selectNumberClusters" id="selectNumberClusters"    style="width: 135px"  >
                                <% for (int i = 0; i <= 20; i++) {
                                %>
                                <option value="<%out.print(i);%>"  <%
                                    if (resultClustering != null && Integer.valueOf(resultClustering.size()) == i) {%>
                                        selected
                                        <%}
                                        %>

                                        ><%out.print(i);%></option>
                                <%}
                                %>
                            </select></td>
                    </tr>


                    <tr>

                        <td style="width:50%; text-align: right; "> 
                            <b>Silhouette Coefficient:</b>
                        </td>
                        <td style="width:50%;  "> 
                            <input style="width:135px" id="clusteringEvaluationText" name="clusteringEvaluationText" type="text" disabled
                                   <%if (averageSilhouetteCoefficient != null) {%>value="<%=averageSilhouetteCoefficient%>"<%}%>
                                   >

                        </td>

                    </tr>
                    <tr>
                        <td style="text-align: center;" colspan="2">
                            <button  id="reClusterButton" name="reClusterButton"  type="button"  
                                     onclick="reClusteringTimeCircular();
                                     "><b>Re Clustering</b></button>


                            <button  id="reProjectButton" name="reProjectButton"  type="button"  
                                     onclick="reHierarchicalProjection();
                                     "><b>Re Projection</b></button>
                            <button  id="updateClusterIntervalButton" name="updateClusterIntervalButton"  type="button"  
                                     onclick="updateClusterIntervalTimeCircular(listIdInterval, listOldCluster, listNewCluster);
                                     "><b>Update </b></button>
                            <button  id="visualizeNormalizedTimeSeriesButton" name="visualizeNormalizedTimeSeriesButton"  type="button"  
                                     onclick="visualizeNormalizedTimeSeriesButton();
                                     "><b>Normalized Time Series </b></button>

                            <button  id="categoriesSource1ProjectionButton" name="categoriesSource1ProjectionButton"  type="button"  
                                     onclick="categoriesSource1ProjectionButton();
                                     "><b>By Categories of Source1 </b></button>
                            <br>                                 
                            <br>                                           
                        </td>
                    </tr>
                   

                </table>
            </td>
            <td >
                <div id="attributes_subset_frame" >
                    <%@ include file="SelectedAttributesSubset.jsp" %>
                </div>
            </td>
        <br>
        </tr>
    </table>
    <% if (colorStyleRadioButton != null && colorStyleRadioButton.equals("category")) {%>
    <table style=" border-color: black;" border="2">
        <tr>
            <td witdh="5px"></td> <td><b>Category</b></td>
        </tr>
        <% for (int i = 0; i < filteredSource1Categories.size(); i++) {
                Color colorCell = colorScaleBackground[filteredSource1CategoriesColors.get(i)];
                int red = colorCell.getRed();
                int green = colorCell.getGreen();
                int blue = colorCell.getBlue();
        %>
        <tr>
            <td witdh="5px" style="background-color: rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>); 
                color:rgb(<%out.print(red);%>,<%out.print(green);%>,<%out.print(blue);%>);">
                __</td><td><%=filteredSource1Categories.get(i)%></td>
        </tr>
        <%}%>
    </table>
    <%}%>
    <table  id="timeMatricesTable" style="text-align: center;margin:0 auto; margin:auto;width: <%=(sizeTable + 40)%>px; ">
        <br>
        <tr>
            <td colspan="2">
                <table style="text-align: center; margin:0 auto; margin:auto; ">
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

                    <tr>

                        <td   colspan="2">
                            <table style="margin:0 auto; margin:auto;">
                                <tr>
                                    <td colspan="3"> <input type="text" id="missingDataThresholdInput" readonly value="100%" style="border:0;text-align: center;">
                                    </td>

                                </tr>
                                <tr><td>0</td>
                                    <td>
                                        <input type="range" id="missingDataSlider" name="missingDataSlider" value="100" min="0" max="100"  style="width: 500px;"
                                               oninput="updateMissingDataThreshold('<%=listTimeIntervalsData.size()%>');" onchange="updateMissingDataThreshold('<%=listTimeIntervalsData.size()%>');"></td>
                                    <!--td style="width: 10px;"></td><td> &nbsp<div id="missingDataSlider" style="width: 500px" ></div>&nbsp</td><td style="width: 10px;"></td-->
                                    <td>100</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td  colspan="2">Haar Level</td>
                    </tr>

                    <tr>
                        <td   colspan="2">
                            <table style="margin:0 auto; margin:auto;">
                                <tr>
                                    <td colspan="3"> <input type="text" id="haarLeveldInput" readonly 
                                                            value="<%=haarLevelRange%>" 
                                                            style="border:0;text-align: center;">
                                    </td>

                                </tr>
                                <tr><td>0</td>
                                    <td>
                                        <input type="range" id="haarLeveldSlider" name="haarLeveldSlider" 
                                               value="<%=haarLevelRange%>" min="0" 
                                               max="<%=maxHaarLevelRange%>"  style="width: 500px;"
                                               oninput="updateHaarLevel();" 
                                               onchange="updateHaarLevel();"></td>
                                    <td><%=maxHaarLevelRange%></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td  colspan="2">Correlation Threshold</td>
                    </tr>

                    <tr>
                        <td   colspan="2">
                            <table style="margin:0 auto; margin:auto;">
                                <tr>
                                    <td colspan="3"> <input type="text" id="corrCoeffInput" 
                                                            readonly value="<%=corrCoeff%>" 
                                                            style="border:0;text-align: center;">
                                    </td>

                                </tr>
                                <tr><td>0.0</td>
                                    <td>
                                        <input type="range" id="corrCoeffSlider" name="corrCoeffSlider" 
                                               value="<%=corrCoeff%>" min="0.0" max="1.0" step="0.1" 
                                               style="width: 500px;"
                                               oninput="updateCorrCoeff();" 
                                               onchange="updateCorrCoeff();"></td>
                                    <td>1.0</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td  colspan="2">Subgroup Size</td>
                    </tr>

                    <tr>
                        <td   colspan="2">
                            <table style="margin:0 auto; margin:auto;">
                                <tr>
                                    <td colspan="3"> <input type="number" id="subGroupSizeInput"
                                                            name="subGroupSizeInput"
                                                            value="<%=subGroupSize%>" 
                                                            style="border:0;text-align: center;">
                                    </td>


                                    <td>
                                        <input name="subGroupSizeButton" id="subGroupSizeButton" type="image" 
                                               src="images/refresh.png" 
                                               style="width:34px;"
                                               alt="Refresh!" onclick="updateSubGroupSize();"
                                               />

                                    </td>

                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table   style="margin:0 auto; margin:auto;border-color: white;  "  border="3">
                                <%  int countCluster = 0;
                                    int countElement = 0;
                                    String listIndices = "";

                                    for (int i = 0; i < numRows && countCluster < resultClustering.size(); i++) {

                                %>  
                                <tr>
                                    <%  for (int j = 0; j < numCols && countCluster < resultClustering.size(); j++) {

                                            if (countElement >= resultClustering.get(countCluster).size()) {
                                                if (resultClustering.get(countCluster).size() == 0) {
                                                    countCluster++;
                                                    countElement = 0;
                                                    if (countCluster >= resultClustering.size()) {
                                                        break;
                                                    }

                                                } else {
                                                    break;
                                                }
                                            }
                                            int index = resultClustering.get(countCluster).get(countElement);
                                            listIndices += index + ",";
                                            String nameAttribute = listTimeIntervalsData.get(index).getNameAttribute();
                                            String source1Attribute = listTimeIntervalsData.get(index).getValueSource();
                                            Color colorBackground = colorScaleBackground[listTimeIntervalsData.get(index).getIndexColorCluster()];
                                            String fontColor = utils.Util.getColorByLuminance(colorBackground);
                                            int borderWidth = 8;//10-
                                            //Color borderColor;
                                            //int colorBorderValue = (int) Math.round(Operations.minmax(listTimeIntervalsData.get(index).getOriginalMissingDataImpact(), 0.f, 100.f, 1.f, 250.f));

                                            //borderColor = colorScaleBorder[colorBorderValue];
                                    %>
                                    <td  style=" background-color: rgb(<%out.print(colorBackground.getRed());%>,<%out.print(colorBackground.getGreen());%>,<%out.print(colorBackground.getBlue());%>); width: <%=sizeTable%>px; text-align:center;" 
                                         ondblclick="focusProjectionCircle('<%=index%>');" >


                                        <table   id="matrix<%=index%>" style=" border-style: solid; border-width: <%=borderWidth%>px;border-color: 	#A8A8A8; text-align: center; width: <%=sizeTable%>px;" >
                                            <tr >
                                                <th  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:14px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                    Cluster#
                                                    <select style="color: black;" name="selectCluster<%=index%>"
                                                            id="selectCluster<%=index%>" 
                                                            onchange="
                                                                    listIdInterval.push('<%=index%>');
                                                                    listOldCluster.push('<%=listTimeIntervalsData.get(index).getCluster()%>');
                                                                    var newCluster = $('#selectCluster<%=index%>').val();
                                                                    listNewCluster.push(newCluster);
                                                            " >
                                                        <%for (int numCluster = 1; numCluster <= resultClustering.size(); numCluster++) {
                                                        %>
                                                        <option value="<%=numCluster%>"
                                                                <%if (numCluster == listTimeIntervalsData.get(index).getCluster()) {%>
                                                                selected
                                                                <%}%>
                                                                ><%=numCluster%> </option>
                                                        <%}%>
                                                        <option value="+1" >+1 </option>
                                                    </select>

                                                    -  <%out.print(nameAttribute);%>

                                                    <input type="checkbox" name="selectedAttributeCheckBox<%=index%>" id="selectedAttributeCheckBox<%=index%>"  value="<%=nameAttribute%>"
                                                           onchange="addRemoveAttributeSubsetSelection('<%=index%>');"
                                                           <% if (listSelectedAttributesSubset.contains(index)) {%>
                                                           checked
                                                           <%}%>>
                                                    <input id="attributeName<%=index%>" hidden="hidden" value="<%=nameAttribute%>">
                                                    <input id="attributeSource1<%=index%>" hidden="hidden" value="<%=source1Attribute%>">
                                                </th>
                                            </tr>
                                            <tr >
                                                <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:13px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                    <%out.print(listTimeIntervalsData.get(index).getCategorySource());%>

                                                </td>
                                            </tr>
                                            <tr >
                                                <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:13px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                    <%out.print(listTimeIntervalsData.get(index).getNameSource() + " " + listTimeIntervalsData.get(index).getValueSource());%>

                                                </td>
                                            </tr>
                                            <tr >
                                                <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                    <%out.print(listTimeIntervalsData.get(index).getInitDate() + " - " + listTimeIntervalsData.get(index).getEndDate()); %></td>
                                            </tr>

                                            <% Matrix matrixTmp = listTimeIntervalsData.get(index).getMatrix();
                                                ArrayList<String> listX = listTimeIntervalsData.get(index).getListLabelsX();
                                                ArrayList<String> listY = listTimeIntervalsData.get(index).getListLabelsY();
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
                                                    <%out.print("Missing data: " + listTimeIntervalsData.get(index).getOriginalMissingDataImpact() + "%");%>
                                                    <input id="missingData<%=index%>" hidden="hidden" value="<%=listTimeIntervalsData.get(index).getOriginalMissingDataImpact()%>">
                                                </td>
                                            </tr>
                                            <tr >
                                                <td  style='font-weight:bold;vertical-align:top;font-family:Arial, sans-serif;font-size:12px;color:<%out.print(fontColor);%>;text-align:center;' colspan="1" >
                                                    <%out.print(" With interpolation: " + listTimeIntervalsData.get(index).getInterpolatedMissingDataImpact() + "%");%></td>
                                            </tr>
                                            <tr><td style="text-align: center;" >
                                                    <table style='font-size:3px; border-style:solid; margin:0 auto; margin:auto;'  >
                                                        <tr>
                                                            <%

                                                                for (int mRow = 0; mRow < matrixTmp.getRows(); mRow++) {%>
                                                            <%for (int mCol = 0; mCol < matrixTmp.getCols(); mCol++) {
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
                                                                        matrixTmp.setOriginalValue(mRow, mCol, originalValue);
                                                                    }

                                                            %>

                                                            <% }%>
                                                            <% }

                                                                TimeCircular timeCircular = new TimeCircular(listTimeIntervalsData.get(index), colorScaleCell, corrCoeff, haarLevelRange, subGroupSize);
                                                                //System.out.println(timeCircular.getTimeCircularJSon());


                                                            %>
                                                            <td  style="width:<%=sizeTable%>px; height:<%=sizeTable%>px">

                                                                <div id="timeCircularTimeMatrix<%=index%>" >  
                                                                    <script type="text/javascript">
                                                                        createTimeMatrixBundleVisualization("timeCircularTimeMatrix<%=index%>",
                                                                                "<%=sizeTable%>", "<%=sizeTable%>", "<%=timeCircular.getTimeCircularJSon()%>");</script> 

                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <%     countElement++;
                                        if ((countElement >= resultClustering.get(countCluster).size()) && ((countCluster + 1) < resultClustering.size())) {
                                            countElement = 0;
                                            countCluster++;
                                        }
                                    %>

                                    <% } %>
                                </tr>

                                <%
                                    }%>
                                <input type="hidden" id="listIndicesString" name="listIndicesString" value="<%=listIndices%>">
                            </table>
                        </td>
                        <td style="position: fixed;">
                            <!--div id="attributes_subset_frame" >
                            <%//@ include file="SelectedAttributesSubset.jsp" %>
                        </div-->
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>



<% } else {%><br>
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