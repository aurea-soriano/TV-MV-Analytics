/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trees.kdtree;

import java.util.ArrayList;
import java.util.Arrays;

/**
 *
 * @author aurea
 */
public class KDTreeTest {

    public static void main(String[] args) {

        ArrayList<KDData> listData = new ArrayList<>();
        listData.add(new KDData(new Point2D(1, 1), new ArrayList<>(Arrays.asList(4, 5))));
        listData.add(new KDData(new Point2D(0, 0), new ArrayList<>(Arrays.asList(1))));
        listData.add(new KDData(new Point2D(80, 80), new ArrayList<>(Arrays.asList(2))));
       listData.add(new KDData(new Point2D(1, 2), new ArrayList<>(Arrays.asList(3))));

        KDTree kdtree = new KDTree();
        kdtree.buildKDTree( 0, listData);

        kdtree.print(kdtree.getRoot(),"root");
    }
}
