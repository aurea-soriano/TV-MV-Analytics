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
public class QuadTreeTest {

    public static void main(String[] args) {

        ArrayList<Point> bounds = new ArrayList<>();
        bounds.add(new Point(0, 0));
        bounds.add(new Point(100, 100));
        QuadTree qt = new QuadTree(bounds,2);
        qt.insert(new Point(0,0),1);
        qt.insert(new Point(80,80),2);
        qt.insert(new Point(1,2),3);
        qt.insert(new Point(1,1),4);
        qt.insert(new Point(1,1),5);
     
        System.out.println(qt.getDepth());
       // qt.print(qt.getRoot());
       
      
    }

}
