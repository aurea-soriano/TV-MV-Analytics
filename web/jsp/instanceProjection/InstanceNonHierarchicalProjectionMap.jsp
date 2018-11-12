<%-- 
    Document   : InstanceProjectionMap
    Created on : Jul 4, 2016, 3:25:33 PM
    Author     : aurea
--%>
<%@page import="distance.Euclidean"%>
<%@page import="distance.PearsonCorrelation"%>
<%@page import="distance.AbstractDissimilarity"%>
<%@page import="distance.ManhattanSimilarity"%>
<%@page import="distance.EuclideanSimilarity"%>
<%@page import="databaseconnection.ConnectionXMLReader"%>
<%@page import="databaseconnection.QueryBuilder"%>
<%@page import="categorization.CategorizationObject"%>
<%@page import="projection.IDMAPProjection"%>
<%@page import="java.util.Collections"%>
<%@page import="color.HeatedObject"%>
<%@page import="clustering.SilhouetteCoefficient"%>
<%@page import="normalization.Standardization"%>
<%@page import="normalization.NormalizeColumns"%>
<%@page import="normalization.Normalization"%>
<%@page import="projection.FastmapProjection"%>
<%@page import="java.awt.Color"%>
<%@page import="dataMaker.TimeInterval"%>
<%@page import="utils.Operations"%>
<%@page import="projection.ForceSchemeProjection2D"%>
<%@page import="projection.ProjClusProjection"%>
<%@page import="projection.LSPProjection2D.ControlPointsType"%>
<%@page import="projection.LSPProjection2D"%>
<%@page import="categorization.Tiwari2011Sigma"%>
<%@page import="categorization.Hegarty2001Sigma"%>
<%@page import="categorization.ITUR2013S4"%>
<%@page import="categorization.Tiwari2011S4"%>
<%@page import="categorization.Hegarty2001S4"%>
<%@page import="categorization.Categorization"%>
<%@page import="matrix.pointsmatrix.AbstractVector"%>
<%@page import="matrix.pointsmatrix.DenseVector"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="utils.Util"%>
<%@page import="java.util.ArrayList"%>
<%@page import="matrix.pointsmatrix.DenseMatrix"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%

    ConnectionXMLReader connectionXMLReader = (ConnectionXMLReader) session.getAttribute("connectionXMLReader");
    ArrayList<TimeInterval> listTimeIntervalAttributes3 = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    Color[] colorScaleBackground = (Color[]) session.getAttribute("colorScaleBackground");
    String selectedAttributes = request.getParameter("selectedAttributes");
    String[] selectedAttributesArray = selectedAttributes.split(",");
    String source2 = request.getParameter("source2");
    String source1 = request.getParameter("source1");
    String[] source1Array = source1.split(",");

    String fromDateStr = request.getParameter("fromDate");
    String toDateStr = request.getParameter("toDate");
    //String intervalTimes = request.getParameter("intervalTimes");
    //String[] intervalTimesArray = intervalTimes.split(",");
    String valueThreshold = request.getParameter("valueThreshold");
    String attributeTarget = request.getParameter("attributeTarget");
    String categorizationId = request.getParameter("categorization");
    String colorStrategy = request.getParameter("colorStrategy");
    String nameProjectionTechnique = request.getParameter("nameProjectionTechnique");
    double stepSlider = 0.0;

    String valueUnitTimeInterval = (String) session.getAttribute("valueUnitTimeInterval");
    String unitTimeInterval = (String) session.getAttribute("unitTimeInterval");
    String aggregationFunction = (String) session.getAttribute("aggregationFunction");

    String user = (String) session.getAttribute("user");
    String driver = (String) session.getAttribute("driver");
    String username = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");
    String url = (String) session.getAttribute("url");

    ArrayList<Float> listKlasses = new ArrayList<Float>();
    AbstractMatrix instanceMatrix = new DenseMatrix();
    String arrayAttributes = "";
    for (int j = 0; j < selectedAttributesArray.length; j++) {
        arrayAttributes = arrayAttributes + "'" + selectedAttributesArray[j] + "'";
        if (j < selectedAttributesArray.length - 1) {
            arrayAttributes = arrayAttributes + ",";
        }
    }
    //arrayAttributes = arrayAttributes + "'" + attributeTarget + "'";
    ArrayList<Float> listLabels = new ArrayList<Float>();
    ArrayList<String> listDates = new ArrayList<String>();

    //categorization 
    ArrayList<CategorizationObject> listCategorization1 = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
    CategorizationObject categorization = listCategorization1.get(Integer.valueOf(categorizationId));

    Float maxValueClassficationAttribute = Float.MIN_VALUE;
    Float minValueClassficationAttribute = Float.MAX_VALUE;
    String combineAllSource1DataFlag = (String) request.getParameter("combineAllSource1DataFlag");

    if (combineAllSource1DataFlag.equals("false")) {

        for (int elemSource1 = 0; elemSource1 < source1Array.length; elemSource1++) {

            String nameFunction = "";
            if (connectionXMLReader.getDataMaxminfunctionTimeinterval() != null && !connectionXMLReader.getDataMaxminfunctionTimeinterval().equals("")) {
                nameFunction = connectionXMLReader.getDataMaxminfunctionTimeinterval();
            } else {
                nameFunction = connectionXMLReader.getDataMaxminfunctionTimeintervalThreshold();
            }

            String queryMaxMinValueFilter = QueryBuilder.getMaxAndMinValueClassificationByIntervalDates(nameFunction, arrayAttributes, attributeTarget, source2, source1Array[elemSource1], fromDateStr, toDateStr, valueThreshold);

            //String queryMaxMinValueFilter = "select * from getmaxandminvalueclassificationbyintervaldates(ARRAY[" + arrayAttributes + "],'" + attributeTarget + "',"
            //       + source2 + "," + source1Array[elemSource1] + ", '" + fromDateStr + "', '" + toDateStr + "'," + valueThreshold + ");";
            System.out.println(queryMaxMinValueFilter);
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultMaxMinValue = null;
            Class.forName(driver).newInstance();
            connection = DriverManager.getConnection(url, username, password);
            preparedStatement = connection.prepareStatement(queryMaxMinValueFilter);
            resultMaxMinValue = preparedStatement.executeQuery();

            if (resultMaxMinValue.next()) {
                float maxValueTmp = Float.valueOf(resultMaxMinValue.getString("maxvalue"));
                if (maxValueTmp > maxValueClassficationAttribute) {
                    maxValueClassficationAttribute = maxValueTmp;
                }
                float minValueTmp = Float.valueOf(resultMaxMinValue.getString("minvalue"));
                if (minValueTmp < minValueClassficationAttribute) {
                    minValueClassficationAttribute = minValueTmp;
                }
            }
        }

        for (int elemSource1 = 0; elemSource1 < source1Array.length; elemSource1++) {

            /* Integer secValueUnitTimeInterval = 0;
            if (unitTimeInterval.equals("year")) {
                secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 365;
            } else if (unitTimeInterval.equals("month")) {
                secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 30;
            } else if (unitTimeInterval.equals("day")) {
                secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24;
            } else if (unitTimeInterval.equals("hour")) {
                secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60;
            } else if (unitTimeInterval.equals("minute")) {
                secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60;
            }
            Integer initTime = 0;
            Integer endTime = 0;

            if (unitTimeInterval.equals("minute")) {
                initTime = 0;
                endTime = 59;
            } else {
                if (unitTimeInterval.equals("hour")) {
                    initTime = 0;
                    endTime = 24;
                } else {
                    if (unitTimeInterval.equals("day")) {
                        initTime = 1;
                        endTime = 31;
                    } else {
                        if (unitTimeInterval.equals("month")) {
                            initTime = 1;
                            endTime = 12;
                        }
                    }
                }
            }
            String query = "";
            if (connectionXMLReader.getInstanceThresholdAttributeName() != null && !connectionXMLReader.getInstanceThresholdAttributeName().equals("")) {
                // System.out.println("there is threshold");
                if (aggregationFunction.equals("max")) {
                    query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMaxFunctionTimeintervalThreshold(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                } else if (aggregationFunction.equals("avg")) {
                    query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataAvgFunctionTimeintervalThreshold(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                } else if (aggregationFunction.equals("min")) {
                    query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataMinFunctionTimeintervalThreshold(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                } else if (aggregationFunction.equals("std")) {
                    query = QueryBuilder.getDataByAggregationFunctionAndThreshold(connectionXMLReader.getDataStdFunctionTimeintervalThreshold(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
                }

            } else {
                //System.out.println("there is no threshold");
                if (aggregationFunction.equals("max")) {

                    query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMaxFunctionTimeinterval(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval);
                } else if (aggregationFunction.equals("avg")) {
                    query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataAvgFunctionTimeinterval(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval);
                } else if (aggregationFunction.equals("min")) {
                    query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataMinFunctionTimeinterval(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval);
                } else if (aggregationFunction.equals("std")) {
                    query = QueryBuilder.getDataByAggregationFunction(connectionXMLReader.getDataStdFunctionTimeinterval(),
                            arrayAttributes, source2, source1Array[elemSource1], fromDateStr, toDateStr, secValueUnitTimeInterval);
                }
            }*/
            String nameFunction = "";
            if (connectionXMLReader.getDataByTimeInterval() != null && !connectionXMLReader.getDataByTimeInterval().equals("")) {
                nameFunction = connectionXMLReader.getDataByTimeInterval();
            } else {
                nameFunction = connectionXMLReader.getDataByTimeIntervalThreshold();
            }
            String queryInstanceProjection = QueryBuilder.getDataByIntervalDates(nameFunction, arrayAttributes, attributeTarget, source2, source1Array[elemSource1], fromDateStr, toDateStr, valueThreshold);

            
            System.out.println(queryInstanceProjection);
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultInstanceProjection = null;
            Class.forName(driver).newInstance();
            connection = DriverManager.getConnection(url, username, password);
            preparedStatement = connection.prepareStatement(queryInstanceProjection);
            resultInstanceProjection = preparedStatement.executeQuery();

            while (resultInstanceProjection.next()) {
                try {

                    String round = resultInstanceProjection.getString("valuesattributes");
                    String[] valuesattributes = round.replace("{", "").replace("}", "").split(",");
                    float[] valuesVector = new float[valuesattributes.length];
                    for (int j = 0; j < valuesattributes.length; j++) {
                        valuesVector[j] = Float.valueOf(valuesattributes[j]);
                    }
                    float valueCategorization = Float.valueOf(resultInstanceProjection.getString("valueclassificationattribute"));
                    //float valueCategorization = Float.valueOf(valuesattributes[valuesattributes.length - 1]);

                    AbstractVector vector = new DenseVector(valuesVector);
                    if (colorStrategy.equals("categorized")) {
                        float valueTypeCategorization = categorization.calculateClass(valueCategorization);
                        vector.setKlass((float) valueTypeCategorization);
                        listKlasses.add((float) valueTypeCategorization);
                    } else {
                        float klass = Math.abs(valueCategorization * 100) / 100;
                        vector.setKlass(klass);
                        listKlasses.add(klass);

                    }

                    instanceMatrix.addRow(vector);

                    listLabels.add(valueCategorization);
                    String date = resultInstanceProjection.getString(connectionXMLReader.getInstanceTimeUTCName());
                    if (date != null) {
                        listDates.add(date);
                    } else {
                        listDates.add("");
                    }

                } catch (Exception e) {

                }
            }

            resultInstanceProjection.close();
            preparedStatement.close();
            connection.close();

            //}
        }
    } else {

        String tmp = "";

        String nameFunction = "";
        if (connectionXMLReader.getDataMaxminfunctionTimeintervalForAllSource1() != null && !connectionXMLReader.equals("")) {
            nameFunction = connectionXMLReader.getDataMaxminfunctionTimeintervalForAllSource1();
        } else {
            nameFunction = connectionXMLReader.getDataMaxminfunctionTimeintervalThresholdForAllSource1();
        }

        String queryMaxMinValueFilter = QueryBuilder.getMaxAndMinValueClassificationByIntervalDatesForAllSource1(nameFunction, arrayAttributes, attributeTarget, source2, fromDateStr, toDateStr, valueThreshold);
        //"select * from getmaxandminvalueclassificationbyintervaldatesforallsat(ARRAY[" + arrayAttributes + "],'"
        //       + attributeTarget + "'," + source2 + ", '" + fromDateStr + "', '" + toDateStr + "'," + valueThreshold + ");";
        System.out.println(queryMaxMinValueFilter);
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultMaxMinValue = null;
        Class.forName(driver).newInstance();
        connection = DriverManager.getConnection(url, username, password);
        preparedStatement = connection.prepareStatement(queryMaxMinValueFilter);
        resultMaxMinValue = preparedStatement.executeQuery();

        if (resultMaxMinValue.next()) {

            float maxValueTmp = Float.valueOf(resultMaxMinValue.getString("maxvalue"));
            if (maxValueTmp > maxValueClassficationAttribute) {
                maxValueClassficationAttribute = maxValueTmp;
            }
            float minValueTmp = Float.valueOf(resultMaxMinValue.getString("minvalue"));
            if (minValueTmp < minValueClassficationAttribute) {
                minValueClassficationAttribute = minValueTmp;
            }
        }

        tmp = "";
        /*
        
        Integer secValueUnitTimeInterval = 0;
        if (unitTimeInterval.equals("year")) {
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 365;
        } else if (unitTimeInterval.equals("month")) {
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24 * 30;
        } else if (unitTimeInterval.equals("day")) {
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60 * 24;
        } else if (unitTimeInterval.equals("hour")) {
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60 * 60;
        } else if (unitTimeInterval.equals("minute")) {
            secValueUnitTimeInterval = Integer.valueOf(valueUnitTimeInterval) * 60;
        }
        Integer initTime = 0;
        Integer endTime = 0;
        if (unitTimeInterval.equals("minute")) {
            initTime = 0;
            endTime = 59;
        } else {
            if (unitTimeInterval.equals("hour")) {
                initTime = 0;
                endTime = 24;
            } else {
                if (unitTimeInterval.equals("day")) {
                    initTime = 1;
                    endTime = 31;
                } else {
                    if (unitTimeInterval.equals("month")) {
                        initTime = 1;
                        endTime = 12;
                    }
                }
            }
        }

        String query = "";
        if (connectionXMLReader.getInstanceThresholdAttributeName() != null && !connectionXMLReader.getInstanceThresholdAttributeName().equals("")) {
            //System.out.println("there is threshold");
            if (aggregationFunction.equals("max")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataMaxFunctionTimeintervalThresholdForAllSource1(),
                        arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
            } else if (aggregationFunction.equals("avg")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataAvgFunctionTimeintervalThresholdForAllSource1(),
                        arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
            } else if (aggregationFunction.equals("min")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataMinFunctionTimeintervalThreshold(),
                        arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
            } else if (aggregationFunction.equals("std")) {
                query = QueryBuilder.getDataByAggregationFunctionAndThresholdForAllSource1(connectionXMLReader.getDataStdFunctionTimeintervalThreshold(),
                        arrayAttributes, source2, fromDateStr, toDateStr, secValueUnitTimeInterval, valueThreshold);
            }

        } else {
            //System.out.println("there is no threshold");
            if (aggregationFunction.equals("max")) {
                query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataMaxFunctionTimeintervalThreshold(),
                        arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                        secValueUnitTimeInterval);
            } else if (aggregationFunction.equals("avg")) {
                query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataAvgFunctionTimeintervalThreshold(),
                        arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                        secValueUnitTimeInterval);
            } else if (aggregationFunction.equals("min")) {
                query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataMinFunctionTimeintervalThreshold(),
                        arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                        secValueUnitTimeInterval);
            } else if (aggregationFunction.equals("std")) {
                query = QueryBuilder.getDataByAggregationFunctionForAllSource1(connectionXMLReader.getDataStdFunctionTimeintervalThreshold(),
                        arrayAttributes, source2, fromDateStr, toDateStr, initTime, endTime, unitTimeInterval,
                        secValueUnitTimeInterval);
            }
        }
        
         */
        nameFunction = "";
        if (connectionXMLReader.getDataByTimeIntervalForAllSource1() != null && !connectionXMLReader.getDataByTimeIntervalForAllSource1().equals("")) {
            nameFunction = connectionXMLReader.getDataByTimeIntervalForAllSource1();
        } else {
            nameFunction = connectionXMLReader.getDataByTimeIntervalThresholdForAllSource1();
        }

        String queryInstanceProjection = QueryBuilder.getDataByIntervalDatesForAllSource1(nameFunction, arrayAttributes, attributeTarget, source2, fromDateStr, toDateStr, valueThreshold);

        System.out.println(queryInstanceProjection);
        connection = null;
        preparedStatement = null;
        ResultSet resultInstanceProjection = null;
        Class.forName(driver).newInstance();
        connection = DriverManager.getConnection(url, username, password);
        preparedStatement = connection.prepareStatement(queryInstanceProjection);
        resultInstanceProjection = preparedStatement.executeQuery();

        while (resultInstanceProjection.next()) {
            try {

                String round = resultInstanceProjection.getString("valuesattributes");
                String[] valuesattributes = round.replace("{", "").replace("}", "").split(",");
                float[] valuesVector = new float[valuesattributes.length];
                for (int j = 0; j < valuesattributes.length; j++) {
                    valuesVector[j] = Float.valueOf(valuesattributes[j]);
                }
                float valueCategorization = Float.valueOf(resultInstanceProjection.getString("valueclassificationattribute"));
                //float valueCategorization = Float.valueOf(valuesattributes[valuesattributes.length - 1]);

                AbstractVector vector = new DenseVector(valuesVector);
                if (colorStrategy.equals("categorized")) {
                    float valueTypeCategorization = categorization.calculateClass(valueCategorization);
                    vector.setKlass((float) valueTypeCategorization);
                    listKlasses.add((float) valueTypeCategorization);
                } else {
                    float klass = Math.abs(valueCategorization * 100) / 100;
                    vector.setKlass(klass);
                    listKlasses.add(klass);

                }
                instanceMatrix.addRow(vector);
                listLabels.add(valueCategorization);
                String date = resultInstanceProjection.getString(connectionXMLReader.getInstanceTimeUTCName());
                if (date != null) {
                    listDates.add(date);
                } else {
                    listDates.add("");
                }

            } catch (Exception e) {

            }
        }
        resultInstanceProjection.close();
        preparedStatement.close();
        connection.close();

        //  }
        //}
    }

    //step slider
    if (colorStrategy.equals(
            "categorized")) {
        stepSlider = 0.5;
    } else {
        stepSlider = 0.1;
    }

    //normalization
    Normalization normalization = new Standardization();
    AbstractMatrix normalizedMatrix = normalization.execute(instanceMatrix);

    //projection
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

    AbstractMatrix projectedMatrix = null;

    if (nameProjectionTechnique.equals("LSP")) {
        LSPProjection2D lsp = new LSPProjection2D();
        lsp.setControlPointsChoice(ControlPointsType.KMEANS);
        //lsp.setNumberNeighbors(3);
        lsp.setNumberControlPoints(normalizedMatrix.getRowCount() / 10);
        projectedMatrix = lsp.project(normalizedMatrix, dissimilarity);
    } else {

        if (nameProjectionTechnique.equals("ProjClusProjection")) {
            ProjClusProjection projectionTechnique2 = new ProjClusProjection();
            projectedMatrix = projectionTechnique2.project(normalizedMatrix, dissimilarity);
        } else {

            if (nameProjectionTechnique.equals("FastMapProjection")) {
                FastmapProjection projectionTechnique4 = new FastmapProjection();
                projectedMatrix = projectionTechnique4.project(normalizedMatrix, dissimilarity);

            } else {
                if (nameProjectionTechnique.equals("ForceSchemeProjection")) {
                    ForceSchemeProjection2D projectionTechnique5 = new ForceSchemeProjection2D();
                    projectedMatrix = projectionTechnique5.project(normalizedMatrix, dissimilarity);
                } else {
                    if (nameProjectionTechnique.equals("IDMAPProjection")) {
                        IDMAPProjection projectionTechnique6 = new IDMAPProjection();
                        projectedMatrix = projectionTechnique6.project(normalizedMatrix, dissimilarity);
                    } else {
                        projectedMatrix = null;
                    }
                }
            }

        }
    }

    //silhouette coefficient
    SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
    float[] silhouetteCoefficients = {0.f};
    try {
        silhouetteCoefficients = silhouetteCoefficient.execute(projectedMatrix, new EuclideanSimilarity());
    } catch (Exception e) {

    }
    float averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
    averageSilhouetteCoefficient = Math.round(averageSilhouetteCoefficient * 100000.f) / 100000.f;

    float maxY = Float.MIN_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE;
    float minX = Float.MAX_VALUE;

    String color4 = "f0f8ff";
    String color3 = "087830";
    String color2 = "ffbf00";
    String color1 = "a40000";

    Color[] colorKlasses = (new HeatedObject()).getColorScale();

    float maxValueKlass = Collections.max(listKlasses);
    float minValueKlass = Collections.min(listKlasses);
    String datasetProjection = "[";
    if (projectedMatrix
            != null) {
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
            int valueX = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(0), minX, maxX, 20.f, 1070.f));
            int valueY = Math.round(Operations.minmax(projectedMatrix.getRow(i).getValue(1), minY, maxY, 20.f, 740.f));

            String colorBackground = "";
            if (colorStrategy.equals("categorized")) {
                if (projectedMatrix.getRow(i).getKlass() == 4.0) {
                    colorBackground = color4;
                } else {
                    if (projectedMatrix.getRow(i).getKlass() == 3.0) {
                        colorBackground = color3;
                    } else {
                        if (projectedMatrix.getRow(i).getKlass() == 2.0) {
                            colorBackground = color2;
                        } else {
                            if (projectedMatrix.getRow(i).getKlass() == 1.0) {
                                colorBackground = color1;
                            }
                        }
                    }
                }
            } else {
                int indexColor = (int) Math.abs(Operations.minmax(listKlasses.get(i), minValueKlass, maxValueKlass, 0.f, 255.f));
                indexColor = 255 - indexColor;
                colorBackground = Integer.toHexString(colorKlasses[indexColor].getRGB()).substring(2);
            }

            datasetProjection += "{\'x\':" + valueX + ", \'y\':" + valueY + ", \'color\': \'" + colorBackground
                    + "\', \'name\': \'" + listLabels.get(i) + "\', \'date\': \'" + listDates.get(i) + "\'},";

        }
        if (datasetProjection.endsWith(",")) {
            datasetProjection = datasetProjection.substring(0, datasetProjection.length() - 1);
        }
    }
    datasetProjection += "]";

    session.setAttribute("projectedMatrixNHP", projectedMatrix);
    session.setAttribute("listKlassesNHP", listKlasses);
    session.setAttribute("listLabelsNHP", listLabels);
    session.setAttribute("listDatesNHP", listDates);
    session.setAttribute("colorStrategyNHP", colorStrategy);
    session.setAttribute("maxXNHP", maxX);
    session.setAttribute("minXNHP", minX);
    session.setAttribute("maxYNHP", maxY);
    session.setAttribute("minYNHP", minY);

    float minValueSlider = ((float) Math.floor(minValueKlass * 100)) / 100.f;
    float maxValueSlider = ((float) Math.ceil(maxValueKlass * 100)) / 100.f;
%>

<table  style="border-color: black;margin:0 auto; margin:auto; width: 1150px; height: 820px;" border="1">
    <tr><td colspan="2" style="text-align: center;">
            <script>
                $(function () {
                    $("#sliderFilterProjection").slider({
                        range: true,
                        min:<%=minValueSlider%>,
                        max:<%=maxValueSlider%>,
                        step:<%=stepSlider%>,
                        values: [<%=minValueSlider%>, <%=maxValueSlider%>],
                        slide: function (event, ui) {
                            $("#minValueInput").val(ui.values[ 0 ]);
                            $("#maxValueInput").val(ui.values[ 1 ]);
                        }
                    });
                    $("#minValueInput").val("" + $("#sliderFilterProjection").slider("values", 0) + "");
                    $("#maxValueInput").val("" + $("#sliderFilterProjection").slider("values", 1 + ""));
                });</script>
            <table style="margin:0 auto; margin:auto;">
                <tr>
                    <td style="text-align: right;">
                        <input type="text" id="minValueInput" readonly  style="border:0; font-weight:bold;text-align: right;"></td>
                    <td style="width: 10px;"></td><td> &nbsp<div id="sliderFilterProjection" style="width: 500px"></div>&nbsp</td><td style="width: 10px;"></td>
                    <td style="text-align: left;"> <input type="text" id="maxValueInput" readonly  style="border:0; font-weight:bold;"></td>
                    <td>  <button  id="filterNHPButton" name="filterNHPButton"  type="button"  onclick="
                            filterNHPButton();"><b>Filter</b></button></td>
                </tr>
            </table>
        </td></tr>
    <tr>
        <td> <b># instances: </b> <%=projectedMatrix.getRowCount()%> <b>- # variables: </b>  <%=selectedAttributesArray.length%>
        </td>
        <td>   <b>Silhouette Coefficient: </b> <%=averageSilhouetteCoefficient%></td>
    </tr> 
    <tr>
        <td style=" width: 1110px; height: 780px;text-align: center;" colspan="2">
               <div id="instanceProjectionMapContent"     >  
                <script type="text/javascript"> createInstanceProjection("instanceProjectionMapContent", "1110", "760", "<%=datasetProjection%>");</script> 
            </div>
        </td>
    </tr>
</table>