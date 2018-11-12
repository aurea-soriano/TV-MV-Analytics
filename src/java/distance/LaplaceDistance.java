/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package distance;

import matrix.pointsmatrix.AbstractVector;

/**
 *
 * @author aurea
 */
public class LaplaceDistance implements AbstractDissimilarity {

    @Override
    public float calculate(AbstractVector v1, AbstractVector v2) {
        assert (v1.size() == v2.size()) : "ERROR: vectors of different sizes!";

        float euclideanValue=  (new EuclideanSimilarity()).calculate(v1, v2);
        
        return (float) Math.expm1(-(euclideanValue/0.01));
    }

}