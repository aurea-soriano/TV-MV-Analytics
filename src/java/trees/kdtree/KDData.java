/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trees.kdtree;

import java.util.ArrayList;
import java.util.Comparator;



/**
 *
 * @author aurea
 */
public class KDData implements Comparable<KDData> {
    
      /**
     * Compares two points by x-coordinate.
     */
    public static final Comparator<KDData> X_ORDER = new XOrder();

    /**
     * Compares two points by y-coordinate.
     */
    public static final Comparator<KDData> Y_ORDER = new YOrder();
    
    private Point2D point;
    private ArrayList<Integer>  label;

    public KDData(Point2D point, ArrayList<Integer> label) {
        this.point = point;
        this.label = label;
    }

    public Point2D getPoint() {
        return point;
    }

    public void setPoint(Point2D point) {
        this.point = point;
    }

    public ArrayList<Integer>  getLabel() {
        return label;
    }

    public void setLabel(ArrayList<Integer>  label) {
        this.label = label;
    }

    @Override
    public int compareTo(KDData that) {
        if (this.getPoint().y() < that.getPoint().y()) return -1;
        if (this.getPoint().y() > that.getPoint().y()) return +1;
        if (this.getPoint().x() < that.getPoint().x()) return -1;
        if (this.getPoint().x() > that.getPoint().x()) return +1;
        return 0;
    }
    
    
    // compare points according to their x-coordinate
    public static class XOrder implements Comparator<KDData> {
        @Override
        public int compare(KDData p, KDData q) {
            if (p.getPoint().x() < q.getPoint().x()) return -1;
            if (p.getPoint().x() > q.getPoint().x()) return +1;
            return 0;
        }
    }

    // compare points according to their y-coordinate
    public static class YOrder implements Comparator<KDData> {
        @Override
        public int compare(KDData p, KDData q) {
            if (p.getPoint().y() < q.getPoint().y()) return -1;
            if (p.getPoint().y() > q.getPoint().y()) return +1;
            return 0;
        }
    }
     /**
     * Return a string representation of this point.
     * @return a string representation of this point in the format (x, y)
     */
    @Override
    public String toString() {
        return "( " + this.getPoint().x() + ", " + this.getPoint().y() + ")";
    }
    
}
