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
public class EuclideanSquared implements AbstractDissimilarity {

    public float calculate(AbstractVector v1, AbstractVector v2) {
        assert (v1.size() == v2.size()) : "ERROR: vectors of different sizes!";

        float n1 = v1.norm();
        float n2 = v2.norm();
        float dot = v1.dot(v2);

        return (float) Math.abs(n1 * n1 + n2 * n2 - 2 * dot);
    }

}