/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trees.quadtree;

import dataMaker.TimeInterval;
import java.awt.Color;
import java.awt.Point;
import java.util.ArrayList;

/**
 *
 * @author aurea
 */
public class QuadTree {

    private QuadTreeNode root;
    private ArrayList<Point> totalBounds;
    private Integer numberPoints = 4;
    private Integer depth = 0;

    public QuadTree(ArrayList<Point> bounds, Integer numberPoints) {
        this.numberPoints = numberPoints;
        this.totalBounds = bounds;
        this.root = new QuadTreeNode(this.totalBounds, 0);
        this.depth = 0;
    }

    public QuadTree(ArrayList<Point> bounds) {
        this.totalBounds = bounds;
        this.root = new QuadTreeNode(this.totalBounds, 0);
        this.depth = 0;
    }

    /**
     *
     * @param points
     */
    public void insert(Point point, Integer label) {
        insert(this.root, point, label);

    }

    private void getSubNodeByLevel(QuadTreeNode node, int level, ArrayList<QuadTreeNode> listSubNodes) {

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
                    getSubNodeByLevel(node.getBottomLeft(), level, listSubNodes);
                    getSubNodeByLevel(node.getBottomRight(), level, listSubNodes);
                    getSubNodeByLevel(node.getTopLeft(), level, listSubNodes);
                    getSubNodeByLevel(node.getTopRight(), level, listSubNodes);
                }
            }
        }
    }

    public String getD3SubNodesByLevel(QuadTreeNode node, int level) {
        String datasetLevel = "[";
        ArrayList<QuadTreeNode> listSubNodes = new ArrayList<>();
        getSubNodeByLevel(node, level, listSubNodes);
        for (QuadTreeNode listSubNode : listSubNodes) {
            ArrayList<Point> points = new ArrayList<>();
            ArrayList<Integer> labels = new ArrayList<>();
            searchContent(listSubNode, points, labels);
            Point centroid = getCentroid(points);
            if (points.size() == 1) {
                datasetLevel += "{\'x\':" + points.get(0).x + ", \'y\':" + points.get(0).y + ",\'color\':\'" + Color.black + "\', \'name\':\'" + "#  Attribute1\'},";
            } else {
                if (points.size() > 1) {
                    datasetLevel += "{\'x\':" + centroid.x + ", \'y\':" + centroid.y + ",\'color\':\'" + Color.black + "\', \'name\':\'" + "# Conjunto de atributos\'},";
                }
            }
        }
        datasetLevel += "]";
        return datasetLevel;
    }

    public int getNumberSubNodesPointsByLevel(QuadTreeNode node, int level, int result) {

        if (node != null && node.getLevel() >= level && node.isLeaf()) {
            return node.getPointsSize();
        }

        if (node != null) {
            return getNumberSubNodesPointsByLevel(node.getBottomLeft(), level, result)
                    + getNumberSubNodesPointsByLevel(node.getTopLeft(), level, result)
                    + getNumberSubNodesPointsByLevel(node.getBottomRight(), level, result)
                    + getNumberSubNodesPointsByLevel(node.getTopRight(), level, result);
        } else {
            return 0;
        }

    }

    public int getDepth() {
        return depth;
    }

    public String getD3SubNodesByLevel(QuadTreeNode node, int level, ArrayList<TimeInterval> listTimeIntervalsData, Color[] colorScaleBackground) {

        String datasetLevel = "[";
        ArrayList<QuadTreeNode> listSubNodes = new ArrayList<>();
        getSubNodeByLevel(node, level, listSubNodes);
        // numberMaxGroup = 0;
        for (QuadTreeNode subNode : listSubNodes) {
            ArrayList<Point> points = new ArrayList<>();
            ArrayList<Integer> labels = new ArrayList<>();
            searchContent(subNode, points, labels);
            Point centroid = getCentroid(points);
            Color colorBackground;
            colorBackground = Color.GRAY.brighter();
            /*  if (numberMaxGroup < points.size());
             {
             numberMaxGroup = points.size();
             }*/
            if (points.size() == 1) {
                int indexColorBackground = listTimeIntervalsData.get(labels.get(0)).getIndexColorCluster();
                if (indexColorBackground != -1) {
                    colorBackground = colorScaleBackground[indexColorBackground];
                }
                datasetLevel += "{\'x\':" + points.get(0).x + ", \'y\':" + points.get(0).y + ",\'num\':" + 1 + ",\'level\':" + subNode.getLevel() + ", \'color\':\'" + 
                        Integer.toHexString(colorBackground.getRGB()).substring(2) + "\', \'name\':\'" + "#" + (listTimeIntervalsData.get(labels.get(0)).getCluster() + 1) +
                        "-" + listTimeIntervalsData.get(labels.get(0)).getNameAttribute() + "- "+ listTimeIntervalsData.get(labels.get(0)).getNameSource()+" " +  listTimeIntervalsData.get(labels.get(0)).getValueSource()+"-"+ listTimeIntervalsData.get(labels.get(0)).getInitHour() + ":00-" + listTimeIntervalsData.get(labels.get(0)).getEndHour() + ":00" + "\', \'id\': "+labels.get(0)+"},";

            } else {
                if (points.size() > 1) {
                    String nameLabel = "";
                    int labelMode = listTimeIntervalsData.get(labels.get(0)).getCluster();
                    boolean flag = true;
                    for (Integer label : labels) {
                        nameLabel += ("#" + (listTimeIntervalsData.get(label).getCluster() + 1) + "- "+ listTimeIntervalsData.get(label).getNameSource()+" " + listTimeIntervalsData.get(label).getValueSource()+ "-" + listTimeIntervalsData.get(label).getNameAttribute() + " ");
                        if (labelMode != listTimeIntervalsData.get(label).getCluster()) {
                            flag = false;
                        }
                    }
                    if (flag == true) {
                        int indexColorBackground = listTimeIntervalsData.get(labels.get(0)).getIndexColorCluster();
                        if (indexColorBackground != -1) {
                            colorBackground = colorScaleBackground[indexColorBackground];
                        }
                    }

                    datasetLevel += "{\'x\':" + centroid.x + ", \'y\':" + centroid.y + ",\'num\':" + points.size() + ",\'level\':" + subNode.getLevel() + ",\'color\':\'" + Integer.toHexString(colorBackground.getRGB()).substring(2) + "\', \'name\':\'" + nameLabel + "\', \'id\': "+-1+"},";
                }
            }
        }
        if (datasetLevel.endsWith(",")) {
            datasetLevel = datasetLevel.substring(0, datasetLevel.length() - 1);
        }

        datasetLevel += "]";
        return datasetLevel;
    }

    public Point getCentroid(ArrayList<Point> listPoints) {
        Point centroid = new Point(0, 0);
        for (Point point : listPoints) {
            centroid.x = centroid.x + point.x;
            centroid.y = centroid.y + point.y;
        }
        if (listPoints.size() > 0) {
            centroid.x = centroid.x / listPoints.size();
            centroid.y = centroid.y / listPoints.size();
        }
        return centroid;
    }

    private void insert(QuadTreeNode node, Point point, Integer label) {
        if (node.isLeaf()) {
            if (node.addPoint(point, label)) {

                //System.out.println("Point was added. :" + point.x + " - " + point.y + " Level " + node.getLevel());
                if (isOverloaded(node)) {
                    // System.out.println("Is overloaded");
                    split(node);
                }
            }
        } else {
            insert(node.getBottomLeft(), point, label);
            insert(node.getBottomRight(), point, label);
            insert(node.getTopLeft(), point, label);
            insert(node.getTopRight(), point, label);
        }

    }

    private void split(QuadTreeNode node) {
        Point initialPoint = new Point();
        Point finalPoint = new Point();
        ArrayList<Point> childBounds;

        //creating topLeft
        initialPoint = new Point(node.getBounds().get(0));
        finalPoint = new Point((node.getBounds().get(0).x + node.getBounds().get(1).x) / 2, (node.getBounds().get(0).y + node.getBounds().get(1).y) / 2);
        childBounds = new ArrayList<>();
        childBounds.add(initialPoint);
        childBounds.add(finalPoint);
        QuadTreeNode childTopLeft = new QuadTreeNode(childBounds, node.getLevel() + 1);
        node.setTopLeft(childTopLeft);

        //creating topRight
        initialPoint = new Point((node.getBounds().get(0).x + node.getBounds().get(1).x) / 2, node.getBounds().get(0).y);
        finalPoint = new Point(node.getBounds().get(1).x, (node.getBounds().get(0).y + node.getBounds().get(1).y) / 2);
        childBounds = new ArrayList<>();
        childBounds.add(initialPoint);
        childBounds.add(finalPoint);
        QuadTreeNode childTopRight = new QuadTreeNode(childBounds, node.getLevel() + 1);
        node.setTopRight(childTopRight);

        //creating bottomLeft
        initialPoint = new Point(node.getBounds().get(0).x, (node.getBounds().get(0).y + node.getBounds().get(1).y) / 2);
        finalPoint = new Point((node.getBounds().get(0).x + node.getBounds().get(1).x) / 2, node.getBounds().get(1).y);
        childBounds = new ArrayList<>();
        childBounds.add(initialPoint);
        childBounds.add(finalPoint);
        QuadTreeNode childBottomLeft = new QuadTreeNode(childBounds, node.getLevel() + 1);
        node.setBottomLeft(childBottomLeft);

        //creating bottomRight
        initialPoint = new Point((node.getBounds().get(0).x + node.getBounds().get(1).x) / 2, (node.getBounds().get(0).y + node.getBounds().get(1).y) / 2);
        finalPoint = new Point(node.getBounds().get(1));
        childBounds = new ArrayList<>();
        childBounds.add(initialPoint);
        childBounds.add(finalPoint);
        QuadTreeNode childBottomRight = new QuadTreeNode(childBounds, node.getLevel() + 1);
        node.setBottomRight(childBottomRight);

        depth = ((node.getLevel() + 1) > depth) ? node.getLevel() + 1 : depth;

        ArrayList<Point> listPoints = node.getPoints();
        ArrayList<Integer> listLabels = node.getLabels();
        for (int i = 0; i < listPoints.size(); i++) {
            insert(node.getBottomLeft(), listPoints.get(i), listLabels.get(i));
            insert(node.getBottomRight(), listPoints.get(i), listLabels.get(i));
            insert(node.getTopLeft(), listPoints.get(i), listLabels.get(i));
            insert(node.getTopRight(), listPoints.get(i), listLabels.get(i));
        }
        node.setPoints(new ArrayList<Point>());
        node.setLabels(new ArrayList<Integer>());
        //System.out.println("Removing level" + node.getLevel());
    }

    public void searchContent(QuadTreeNode node, ArrayList<Point> listPoints, ArrayList<Integer> listLabels) {
        if (node.isLeaf()) {
            listPoints.addAll(node.getPoints());
            listLabels.addAll(node.getLabels());
        } else {
            searchContent(node.getBottomLeft(), listPoints, listLabels);
            searchContent(node.getBottomRight(), listPoints, listLabels);
            searchContent(node.getTopLeft(), listPoints, listLabels);
            searchContent(node.getTopRight(), listPoints, listLabels);
        }
    }

    private boolean isOverloaded(QuadTreeNode node) {

        return node.getPointsSize() > numberPoints;
    }

    public QuadTreeNode getRoot() {
        return root;
    }

    public void setRoot(QuadTreeNode root) {
        this.root = root;
    }

    public void print(QuadTreeNode node) {
        if (node != null) {
            System.out.println("Node Data " + node.getPointsSize() + " Level " + node.getLevel());
            if (!node.isLeaf()) {
                print(node.getBottomLeft());
                print(node.getTopLeft());
                print(node.getBottomRight());
                print(node.getTopRight());
            }
        }

    }
}
