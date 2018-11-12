/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package distance;

import matrix.pointsmatrix.AbstractVector;

/**
 *
 * @author Aurea Soriano Vargas
 */
public class ChiSquare implements AbstractDissimilarity {

    public float calculate(AbstractVector v1, AbstractVector v2) {
        assert (v1.size() == v2.size()) : "ERROR: vectors of different sizes!";

        float n1 = v1.norm();
        float n2 = v2.norm();
        
        return (float) Math.pow(n1-n2,2) / (float) Math.abs(n1-n2);
    }

}
