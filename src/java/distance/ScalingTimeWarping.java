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
public class ScalingTimeWarping extends Object implements AbstractDissimilarity {

       public float calculate(AbstractVector v1, AbstractVector v2) {

        float[] Q;
        float[] C;
        if (v1.getValues().length < v2.getValues().length) {
            Q = v1.getValues();
            C = v2.getValues();
        } else {
            Q = v2.getValues();
            C = v1.getValues();
        }
        DynamicTimeWarping dtw= new DynamicTimeWarping();
        float bestMatchVal = Float.POSITIVE_INFINITY;
        float bestScalingFactor = 0;
        for (int p = Q.length; p <= C.length; p++) {
            float[] QP = rescale(Q, p);
            float Ctrunk[] = new float[p];
            for (int i = 0; i < p; i++) {
                Ctrunk[i] = C[i];
            }
            
            
            float distance = dtw.calculate(QP, Ctrunk);
            if (distance < bestMatchVal) {
                bestMatchVal = distance;
                bestScalingFactor = (float) p / (float) Q.length;
            }
        }

        return bestMatchVal;

    }



    float[] rescale(float[] Q, int p) {
        float[] QP = new float[p];
        CubicInterpolator interpolator = new CubicInterpolator();
        float hop = (float)(Q.length)/p;
        float sumHop =0.f;
        for (int i = 0; i < p-1; i++) {
            QP[i] = interpolator.getValue(Q, sumHop);
            sumHop+=hop;
        }
        QP[p-1] = Q[Q.length-1];
        return QP;
    }

    public static class CubicInterpolator {

        public static float getValue(float[] p, float x) {
            int xi = (int) x;
            x -= xi;
            float p0 = p[Math.max(0, xi - 1)];
            float p1 = p[xi];
            float p2 = p[Math.min(p.length - 1, xi + 1)];
            float p3 = p[Math.min(p.length - 1, xi + 2)];
            return (float) (p1 + 0.5 * x * (p2 - p0 + x * (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3 + x * (3.0 * (p1 - p2) + p3 - p0))));
        }
    }
    
}
