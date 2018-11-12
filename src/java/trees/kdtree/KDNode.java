/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trees.kdtree;

import java.util.ArrayList;

/**
 *
 * @author aurea
 */
public class KDNode {

    private Point2D point;
    private ArrayList<Integer> label;
    KDNode left;
    KDNode right;
    private Integer level;

    public KDNode(Point2D point, ArrayList<Integer> label, Integer level) {
        this.point = point;
        this.label = label;
        this.level = level;
    }

    public KDNode(Integer level) {
        this.point = null;
        this.label = null;
        this.level = level;
    }

    public Point2D getPoint() {
        return point;
    }

    public void setPoint(Point2D point) {
        this.point = point;
    }

    public KDNode getLeft() {
        return left;
    }

    public KDNode getRight() {
        return right;
    }

    public ArrayList<Integer>  getLabel() {
        return label;
    }

    public void setLabel(ArrayList<Integer>  label) {
        this.label = label;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public boolean isLeaf() {
        return left == null && right == null;
    }



}
