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
public class PearsonCorrelation implements AbstractDissimilarity {

    public float calculate(AbstractVector v1, AbstractVector v2) {
        assert (v1.size() == v2.size()) : "ERROR: vectors of different sizes!";
        float pearson= covariance(v1, v2) / (standarddeviation(v1) * standarddeviation(v2));
        return 1.f-pearson;
    }

    public static float covariance(AbstractVector v1, AbstractVector v2) {

        float cov = 0.f;
        for (int i = 0; i < v1.size(); i++) {
            cov += (v1.getValue(i) - mean(v1)) * (v2.getValue(i) - mean(v2));
        }
        return cov / (v1.size() - 1);
    }

    public static float mean(AbstractVector v1) {

        float sum = 0.f;
        for (int i = 0; i < v1.size(); i++) {
            sum += v1.getValue(i);
        }
        return sum / v1.size();
    }

    public static float standarddeviation(AbstractVector v1) {
        float mean = mean(v1);
        float std = 0.f;
        for (int i = 0; i < v1.size(); i++) {
            std += Math.pow(v1.getValue(i) - mean, 2);
        }
        return (float) Math.sqrt(std / (v1.size() - 1));

    }
}
