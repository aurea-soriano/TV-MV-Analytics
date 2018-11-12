/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trees.kdtree;

import categorization.Categorization;
import categorization.CategorizationObject;
import dataMaker.TimeInterval;
import java.awt.Color;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import matrix.pointsmatrix.AbstractMatrix;
import trees.kdtree.KDData.XOrder;
import trees.kdtree.KDData.YOrder;
import utils.Operations;

/**
 *
 * @author aurea
 */
public class KDTree implements Cloneable {

    private KDNode root;
    private Integer totalLevels = 0;

    @Override
    public Object clone() throws CloneNotSupportedException {

        return super.clone();

    }

    /*
     * construct an empty set of points
     */
    public KDTree() {

    }

    public Integer getDepth() {
        return totalLevels;
    }

    public KDNode getRoot() {
        return root;
    }

    public ArrayList<ArrayList<KDData>> divideByMedian(ArrayList<KDData> points, int depth) {

        ArrayList<KDData> sortedPoints = (ArrayList<KDData>) points.clone();

        if (depth % 2 == 0) {
            Collections.sort(sortedPoints, new XOrder());
        } else {
            Collections.sort(sortedPoints, new YOrder());
        }

        /*   System.out.println("sortedPoints");
         for (KDData sortedPoint : sortedPoints) {
         System.out.println(sortedPoint.toString());
         }
         System.out.println("****");*/
        int newSize = (points.size() - 1) / 2;
        ArrayList<KDData> leftPoints = new ArrayList<>(sortedPoints.subList(0, newSize + 1));
        /*     System.out.println("leftPoints");
         for (KDData sortedPoint : leftPoints) {
         System.out.println(sortedPoint.toString());
         }
         System.out.println("****");*/
        ArrayList<KDData> rightPoints = new ArrayList<>();
        if (newSize + 1 < sortedPoints.size()) {
            rightPoints = new ArrayList<>(sortedPoints.subList(newSize + 1, sortedPoints.size()));
        }
        /*  System.out.println("rightPoints");
         for (KDData sortedPoint : rightPoints) {
         System.out.println(sortedPoint.toString());
         }
         System.out.println("****");*/
        ArrayList<ArrayList<KDData>> dividedLists = new ArrayList<>();
        dividedLists.add(leftPoints);
        dividedLists.add(rightPoints);
        return dividedLists;

    }

    public void buildKDTree(int depth, ArrayList<KDData> points) {

        if (points.isEmpty()) {
            return;
        }
        if (points.size() == 1) {
            this.root = new KDNode(points.get(0).getPoint(), points.get(0).getLabel(), depth);
        } else {
            ArrayList<ArrayList<KDData>> dividedLists = divideByMedian(points, depth);
            this.root = new KDNode(depth);
            if (totalLevels < depth);
            {
                totalLevels = depth;
            }
            this.root.left = buildKDTree(this.root.left, depth + 1, dividedLists.get(0));
            this.root.right = buildKDTree(this.root.right, depth + 1, dividedLists.get(1));
        }

    }

    public KDNode buildKDTree(KDNode currentNode, int depth, ArrayList<KDData> points) {
        if (points.isEmpty()) {
            return null;
        }
        if (points.size() == 1) {
            currentNode = new KDNode(points.get(0).getPoint(), points.get(0).getLabel(), depth);
            if (totalLevels < depth);
            {
                totalLevels = depth;
            }
            return currentNode;
            //System.out.println("point "+points.get(0).getPoint()+" label "+ points.get(0).getLabel()+" depth "+depth);

        } else {
            boolean equality = true;
            KDData previousData = points.get(0);
            ArrayList<Integer> listBigLabels = new ArrayList<Integer>();
            listBigLabels.addAll(points.get(0).getLabel());
            for (int i = 1; i < points.size(); i++) {
                listBigLabels.addAll(points.get(i).getLabel());
                if (!points.get(i).equals(previousData)) {
                    equality = false;
                    break;
                }
            }

            if (equality == true) {
                currentNode = new KDNode(points.get(0).getPoint(), listBigLabels, depth);
                if (totalLevels < depth);
                {
                    totalLevels = depth;
                }
                return currentNode;
            } else {
                ArrayList<ArrayList<KDData>> dividedLists = divideByMedian(points, depth);
                currentNode = new KDNode(depth);
                if (totalLevels < depth);
                {
                    totalLevels = depth;
                }
                currentNode.left = buildKDTree(currentNode.left, depth + 1, dividedLists.get(0));
                currentNode.right = buildKDTree(currentNode.right, depth + 1, dividedLists.get(1));
                return currentNode;
            }

        }

    }

    private void getSubNodeByLevel(KDNode node, int level, ArrayList<KDNode> listSubNodes) {

        if (node == null) {
            return;
        }
        if (node.getLevel().equals(level)) {
            listSubNodes.add(node);
        } else {
            if (node.getLevel() < (level)) {
                if (node.isLeaf()) {
                    listSubNodes.add(node);
                } else {
                    getSubNodeByLevel(node.left, level, listSubNodes);
                    getSubNodeByLevel(node.right, level, listSubNodes);
                }
            }
        }
    }

    public void searchContent(KDNode node, ArrayList<Point2D> listPoints, ArrayList<ArrayList<Integer>> listLabels) {
        if (node.isLeaf()) {
            listPoints.add(node.getPoint());
            listLabels.add(node.getLabel());
        } else {
            searchContent(node.left, listPoints, listLabels);
            searchContent(node.right, listPoints, listLabels);
        }
    }

    public String getD3SubNodesByLevel(KDNode node, int level) {
        String datasetLevel = "[";
        ArrayList<KDNode> listSubNodes = new ArrayList<>();
        getSubNodeByLevel(node, level, listSubNodes);
        for (KDNode listSubNode : listSubNodes) {
            ArrayList<Point2D> points = new ArrayList<>();
            ArrayList<ArrayList<Integer>> labels = new ArrayList<>();
            searchContent(listSubNode, points, labels);
            Point2D centroid = getCentroid(points);
            if (points.size() == 1) {
                datasetLevel += "{\'x\':" + points.get(0).x() + ", \'y\':" + points.get(0).y() + ",\'color\':\'" + Color.black + "\', \'name\':\'" + "#  Attribute1\'},";
            } else {
                if (points.size() > 1) {
                    datasetLevel += "{\'x\':" + centroid.x() + ", \'y\':" + centroid.y() + ",\'color\':\'" + Color.black + "\', \'name\':\'" + "# Conjunto de atributos\'},";
                }
            }
        }
        datasetLevel += "]";
        return datasetLevel;
    }

    public int getNumberSubNodesPointsByLevel(KDNode node, int level, int result) {

        if (node != null && node.getLevel() >= level && node.isLeaf()) {
            return 1;
        }

        if (node != null) {
            return getNumberSubNodesPointsByLevel(node.left, level, result)
                    + getNumberSubNodesPointsByLevel(node.right, level, result);
        } else {
            return 0;
        }

    }

    public String getD3InstancesSubNodesByLevel(KDNode node, int level, AbstractMatrix projectedMatrix, String colorStrategy,
            Color[] colorScaleBackground, ArrayList<Float> listKlasses, ArrayList<String> listDates,
            CategorizationObject categorization) {

        float maxValueKlass = Collections.max(listKlasses);
        float minValueKlass = Collections.min(listKlasses);

        Color color4 = Color.WHITE;
        Color color3 = Color.GREEN;
        Color color2 = Color.YELLOW;
        Color color1 = Color.RED;
        String datasetLevel = "[";
        ArrayList<KDNode> listSubNodes = new ArrayList<>();
        getSubNodeByLevel(node, level, listSubNodes);
        // numberMaxGroup = 0;
        for (KDNode subNode : listSubNodes) {
            ArrayList<Point2D> points = new ArrayList<>();
            ArrayList<ArrayList<Integer>> labels = new ArrayList<>();

            searchContent(subNode, points, labels);
            Point2D centroid = getCentroid(points);
            Color colorBackground;
            colorBackground = Color.GRAY.brighter();

            int count = 0;
            for (int j = 0; j < labels.size(); j++) {
                count += labels.get(j).size();
            }
            if (count == 1) {
                Integer index = labels.get(0).get(0);
                if (colorStrategy.equals("categorized")) {
                    if (projectedMatrix.getRow(index).getKlass() == 4.0) {
                        colorBackground = color4;
                    } else {
                        if (projectedMatrix.getRow(index).getKlass() == 3.0) {
                            colorBackground = color3;
                        } else {
                            if (projectedMatrix.getRow(index).getKlass() == 2.0) {
                                colorBackground = color2;
                            } else {
                                if (projectedMatrix.getRow(index).getKlass() == 1.0) {
                                    colorBackground = color1;
                                }
                            }
                        }
                    }
                } else {
                    int indexColor = (int) Math.abs(Operations.minmax(listKlasses.get(index), minValueKlass, maxValueKlass, 0.f, 255.f));
                    indexColor = 255 - indexColor;
                    colorBackground = colorScaleBackground[indexColor];
                    //Integer.toHexString(colorKlasses[indexColor].getRGB()).substring(2);
                }

                datasetLevel += "{\'x\':" + points.get(0).x() + ", \'y\':" + points.get(0).y()
                        + ",\'num\':" + 1 + ",\'level\':" + subNode.getLevel() + ", \'color\':\'"
                        + Integer.toHexString(colorBackground.getRGB()).substring(2)
                        + "\', \'name\':\'" + listKlasses.get(index) + "\', \'date\': \'" + listDates.get(index) + "\', \'id\': " + index + "},";

            } else {
                if (points.size() > 1) {
                    String nameLabel = "";
                    String date = "";
                    float labelMode = projectedMatrix.getRow(labels.get(0).get(0)).getKlass();
                    boolean flag = true;
                    float meanColor = 0.f;
                    int countMeanColor = 0;
                    ArrayList<Float> countLabels = new ArrayList<Float>();

                    if (colorStrategy.equals("categorized")) {
                        countLabels = new ArrayList<Float>();
                        countLabels.add(0.f);
                        countLabels.add(0.f);
                        countLabels.add(0.f);
                        if (Float.valueOf(categorization.getNumberClasses()) > 3) {
                            countLabels.add(0.f);
                        }
                    } else {
                        countLabels = new ArrayList<Float>();
                    }
                    for (int i = 0; i < labels.size(); i++) {
                        for (int j = 0; j < labels.get(i).size(); j++) {
                            int index = labels.get(i).get(j);
                            meanColor += projectedMatrix.getRow(index).getKlass();
                            countMeanColor++;
                            if (colorStrategy.equals("categorized")) {
                                int positionCategory = (int) projectedMatrix.getRow(index).getKlass() - 1;
                                countLabels.set(positionCategory, countLabels.get(positionCategory) + 1);
                            } else {
                                countLabels.add(projectedMatrix.getRow(index).getKlass());
                            }
                            if (labelMode != projectedMatrix.getRow(index).getKlass()) {
                                flag = false;
                                break;
                            }
                        }
                    }
                    int numPoints = 0;
                    if (colorStrategy.equals("categorized")) {
                        numPoints += (countLabels.get(0) + countLabels.get(1) + countLabels.get(2));
                        nameLabel = "High: " + countLabels.get(0) + ". "
                                + " Medium: " + countLabels.get(1) + ". "
                                + " Low: "
                                + countLabels.get(2) + ". ";
                        if (Float.valueOf(categorization.getNumberClasses()) > 3) {
                            nameLabel += "Very low:" + countLabels.get(3) + "  instances.";
                            numPoints += countLabels.get(3);
                        }
                    } else {
                        Collections.sort(countLabels);
                        numPoints = countLabels.size();
                        nameLabel += ("[ " + countLabels.get(0) + " - " + countLabels.get(countLabels.size() - 1) + " ] (" + countLabels.size() + ")");
                    }
                    date = "undefined";

                    if (flag == true) {
                        Integer index = labels.get(0).get(0);
                        if (colorStrategy.equals("categorized")) {
                            if (projectedMatrix.getRow(index).getKlass() == 4.0) {
                                colorBackground = color4;
                            } else {
                                if (projectedMatrix.getRow(index).getKlass() == 3.0) {
                                    colorBackground = color3;
                                } else {
                                    if (projectedMatrix.getRow(index).getKlass() == 2.0) {
                                        colorBackground = color2;
                                    } else {
                                        if (projectedMatrix.getRow(index).getKlass() == 1.0) {
                                            colorBackground = color1;
                                        } else {
                                            if (countLabels.get(0) >= countLabels.get(1) && countLabels.get(0) >= countLabels.get(2)) {
                                                colorBackground = color1;
                                            } else {
                                                if (countLabels.get(1) >= countLabels.get(0) && countLabels.get(1) >= countLabels.get(2)) {
                                                    colorBackground = color2;
                                                } else {
                                                    if (countLabels.get(2) >= countLabels.get(0) && countLabels.get(2) >= countLabels.get(1)) {
                                                        colorBackground = color3;
                                                    } else {

                                                    }

                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            int indexColor = (int) Math.abs(Operations.minmax(meanColor / countMeanColor, minValueKlass, maxValueKlass, 0.f, 255.f));
                            indexColor = 255 - indexColor;
                            colorBackground = colorScaleBackground[indexColor];
                            //Integer.toHexString(colorKlasses[indexColor].getRGB()).substring(2);
                        }
                    } else {
                        if (!colorStrategy.equals("categorized")) {
                            int indexColor = (int) Math.abs(Operations.minmax(meanColor / countMeanColor, minValueKlass, maxValueKlass, 0.f, 255.f));
                            indexColor = 255 - indexColor;
                            colorBackground = colorScaleBackground[indexColor];
                        }
                    }

                    datasetLevel += "{\'x\':" + centroid.x() + ", \'y\':" + centroid.y() + ",\'num\':" + numPoints + ",\'level\':"
                            + subNode.getLevel() + ",\'color\':\'" + Integer.toHexString(colorBackground.getRGB()).substring(2)
                            + "\', \'name\':\'" + nameLabel + "\', \'date\': \'" + date + "\', \'id\': " + -1 + "},";
                }
            }
        }
        if (datasetLevel.endsWith(",")) {
            datasetLevel = datasetLevel.substring(0, datasetLevel.length() - 1);
        }

        datasetLevel += "]";
        return datasetLevel;
    }

    public String getD3VariableSubNodesByLevel(KDNode node, int level, ArrayList<TimeInterval> listTimeIntervalsData, Color[] colorScaleBackground) {
        Color[] colorScaleBorder = (new color.BTC()).getColorScale();
        String datasetLevel = "[";
        ArrayList<KDNode> listSubNodes = new ArrayList<>();
        getSubNodeByLevel(node, level, listSubNodes);
        // numberMaxGroup = 0;
        for (KDNode subNode : listSubNodes) {
            ArrayList<Point2D> points = new ArrayList<>();
            ArrayList<ArrayList<Integer>> labels = new ArrayList<>();

            searchContent(subNode, points, labels);
            Point2D centroid = getCentroid(points);
            Color colorBackground;
            colorBackground = Color.GRAY.brighter();
            /*  if (numberMaxGroup < points.size());
             {
             numberMaxGroup = points.size();
             }*/
            int count = 0;
            for (int i = 0; i < labels.size(); i++) {
                count += labels.get(i).size();
            }
            if (count == 1) {
                Integer index = labels.get(0).get(0);
                int indexColorBackground = listTimeIntervalsData.get(index).getIndexColorCluster();
                if (indexColorBackground != -1) {
                    colorBackground = colorScaleBackground[indexColorBackground];
                }
                int colorBorderValue = (int) Math.round(Operations.minmax(listTimeIntervalsData.get(index).getInterpolatedMissingDataImpact(), 0.f, 100.f, 1.f, 250.f));
                Color colorBorder = colorScaleBorder[colorBorderValue];
                datasetLevel += "{\'x\':" + points.get(0).x() + ", \'y\':" + points.get(0).y() + ",\'num\':" + 1 + ",\'level\':" + subNode.getLevel() + ", \'color\':\'"
                        + Integer.toHexString(colorBackground.getRGB()).substring(2) + "\', \'name\':\'" + "#" + (listTimeIntervalsData.get(index).getCluster())
                        + "-" + listTimeIntervalsData.get(index).getNameAttribute() + "- " + listTimeIntervalsData.get(index).getNameSource() + " " + listTimeIntervalsData.get(index).getValueSource()
                        + "\', \'id\': " + index
                        + ", \'bordercolor\':\'" + Integer.toHexString(colorBorder.getRGB()).substring(2) + "\'},";

            } else {
                if (points.size() > 1) {
                    String nameLabel = "";
                    int borderValueSum = 0;
                    int countItems = 0;
                    int labelMode = listTimeIntervalsData.get(labels.get(0).get(0)).getCluster();
                    boolean flag = true;
                    for (int i = 0; i < labels.size(); i++) {
                        for (int j = 0; j < labels.get(i).size(); j++) {
                            int index = labels.get(i).get(j);
                            nameLabel += ("#" + (listTimeIntervalsData.get(index).getCluster()) + "-" + listTimeIntervalsData.get(index).getNameAttribute() + "- " + listTimeIntervalsData.get(index).getNameSource() + " " + listTimeIntervalsData.get(index).getValueSource());
                            int colorBorderValue = (int) Math.round(Operations.minmax(listTimeIntervalsData.get(index).getInterpolatedMissingDataImpact(), 0.f, 100.f, 1.f, 250.f));
                            borderValueSum += colorBorderValue;
                            countItems++;
                            if (labelMode != listTimeIntervalsData.get(index).getCluster()) {
                                flag = false;
                                break;
                            }
                        }
                    }
                    if (flag == true) {
                        int indexColorBackground = listTimeIntervalsData.get(labels.get(0).get(0)).getIndexColorCluster();
                        if (indexColorBackground != -1) {
                            colorBackground = colorScaleBackground[indexColorBackground];
                        }
                    }
                    int colorBorderValue = 1;
                    if (countItems > 0) {
                        colorBorderValue = borderValueSum / countItems;
                    }
                    Color colorBorder = colorScaleBorder[colorBorderValue];
                    datasetLevel += "{\'x\':" + centroid.x() + ", \'y\':" + centroid.y() + ",\'num\':" + points.size() + ",\'level\':"
                            + subNode.getLevel() + ",\'color\':\'" + Integer.toHexString(colorBackground.getRGB()).substring(2)
                            + "\', \'name\':\'" + nameLabel + "\', \'id\': " + -1 + ", \'bordercolor\':\'" + Integer.toHexString(colorBorder.getRGB()).substring(2) + "\'},";
                }
            }
        }
        if (datasetLevel.endsWith(",")) {
            datasetLevel = datasetLevel.substring(0, datasetLevel.length() - 1);
        }

        datasetLevel += "]";
        return datasetLevel;
    }

    public Point2D getCentroid(ArrayList<Point2D> listPoints) {
        Point2D centroid = new Point2D(0, 0);
        for (Point2D point : listPoints) {
            centroid = new Point2D(centroid.x() + point.x(), centroid.y() + point.y());
        }
        if (listPoints.size() > 0) {
            centroid = new Point2D(centroid.x() / listPoints.size(), centroid.y() / listPoints.size());
        }
        return centroid;
    }

    public void print(KDNode node, String orientation) {
        System.out.println("entro");
        if (node != null) {
            System.out.println("Node Data " + node.getPoint() + " Level " + node.getLevel() + " or " + orientation);
            if (!node.isLeaf()) {
                print(node.left, "left");
                print(node.right, "right");
            }
        }

    }
}
