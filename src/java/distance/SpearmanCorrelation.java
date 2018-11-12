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
public class SpearmanCorrelation implements AbstractDissimilarity {
    
    public float calculate(AbstractVector v1, AbstractVector v2) {
        assert (v1.size() == v2.size()) : "ERROR: vectors of different sizes!";
        float[] orderedValues1 = (float[]) v1.getValues().clone();
        float[] orderedValues2 = (float[]) v2.getValues().clone();
        java.util.Arrays.sort(orderedValues1);
        java.util.Arrays.sort(orderedValues2);
        float spearman = 0.f;
        for (int i = 0; i < v1.size(); i++) {
            float d = statisticalOrder(orderedValues1, v1.getValue(i)) - statisticalOrder(orderedValues2, v2.getValue(i));
            spearman += Math.pow(d, 2);
        }
        spearman = (float) ((spearman * 6) / (v1.size() * (Math.pow(v1.size(), 2) - 1)));
        //return 1 - spearman;
        return spearman;
    }
    
    
    public static float statisticalOrder(float[] orderedValues, double value) {

        int sumIndex = 0;
        int countIndex = 0;
        for (int i = 0; i < orderedValues.length; i++) {
            if (value == orderedValues[i]) {
                sumIndex = sumIndex + i + 1;
                countIndex++;
            } else {
                if (countIndex > 0) {
                    return (float) sumIndex / (float) countIndex;
                }
            }

        }
        return (float) sumIndex / (float) countIndex;
    }
}