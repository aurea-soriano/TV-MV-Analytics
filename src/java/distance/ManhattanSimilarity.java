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
public class ManhattanSimilarity implements AbstractDissimilarity {

    @Override
    public float calculate(AbstractVector v1, AbstractVector v2) {
        assert (v1.size() == v2.size()) : "ERROR: vectors of different sizes!";

        float result =0.f;
        for(int i =0; i<v1.size();i++)
        {
            result+=Math.abs(v1.getValue(i)-v2.getValue(i));
        }
        return result;
        
    }
}
