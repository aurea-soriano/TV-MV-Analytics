/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trees.quadtree;

import java.awt.Point;
import java.util.ArrayList;

/**
 *
 * @author aurea
 */
public class QuadTreeNode {

    private ArrayList<Point> points;
    private ArrayList<Integer> labels;
    private ArrayList<Point> bounds;
    private QuadTreeNode bottomLeft;
    private QuadTreeNode bottomRight;
    private QuadTreeNode topLeft;
    private QuadTreeNode topRight;
    private Integer level;

    public QuadTreeNode(ArrayList<Point> bounds, Integer level) {
        this.points = new ArrayList<>();
        this.labels = new ArrayList<>();
        this.bounds = bounds;
        this.level = level;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public boolean addPoint(Point point, Integer label) {
        if (isPointInBounds(point)) {
            //System.out.println("bounds " + bounds);
            if (!points.contains(point)) {
                //System.out.println("Really entered!");
                points.add(point);
                labels.add(label);
            }
            return true;
        }
        return false;
    }

    public boolean isPointInBounds(Point point) {

        if (point.x >= bounds.get(1).x) {
            return false;
        }
        if (point.x < bounds.get(0).x) {
            return false;
        }
        if (point.y >= bounds.get(1).y) {
            return false;
        }
        if (point.y < bounds.get(0).y) {
            return false;
        }
        return true;
    }

    public Integer getPointsSize() {
        return points.size();
    }

    public ArrayList<Point> getPoints() {
        return points;
    }

    public void setPoints(ArrayList<Point> points) {
        this.points = points;
    }

    public ArrayList<Integer> getLabels() {
        return labels;
    }

    public void setLabels(ArrayList<Integer> labels) {
        this.labels = labels;
    }

    public ArrayList<Point> getBounds() {
        return bounds;
    }

    public void setBounds(ArrayList<Point> bounds) {
        this.bounds = bounds;
    }

    public boolean isLeaf() {
        return bottomLeft == null && bottomRight == null && topLeft == null && topRight == null;
    }

    public QuadTreeNode getBottomLeft() {
        return bottomLeft;
    }

    public void setBottomLeft(QuadTreeNode bottomLeft) {
        this.bottomLeft = bottomLeft;
    }

    public QuadTreeNode getBottomRight() {
        return bottomRight;
    }

    public void setBottomRight(QuadTreeNode bottomRight) {
        this.bottomRight = bottomRight;
    }

    public QuadTreeNode getTopLeft() {
        return topLeft;
    }

    public void setTopLeft(QuadTreeNode topLeft) {
        this.topLeft = topLeft;
    }

    public QuadTreeNode getTopRight() {
        return topRight;
    }

    public void setTopRight(QuadTreeNode topRight) {
        this.topRight = topRight;
    }

}
