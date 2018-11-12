/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package moments;

import java.util.ArrayList;
import utils.Operations;

/**
 *
 * @author aurea
 */
public class ZernikeMoment2 {

    double[][] measureMatrix;

    public double[][] calculateMeasureMatrix(ArrayList<ArrayList<Double>> listZernikeMomentVectors) {

        measureMatrix = new double[listZernikeMomentVectors.size()][listZernikeMomentVectors.size()];

        double maxValue = Double.NEGATIVE_INFINITY;
        double minValue = Double.POSITIVE_INFINITY;
        for (int i = 0; i < listZernikeMomentVectors.size(); i++) {
            for (int j = i; j < listZernikeMomentVectors.size(); j++) {
                measureMatrix[j][i] = measureMatrix[i][j] = Operations.euclideanTwoVectors(listZernikeMomentVectors.get(i), listZernikeMomentVectors.get(j));
                if (maxValue < measureMatrix[j][i]) {
                    maxValue = measureMatrix[j][i];
                }
                if (minValue > measureMatrix[j][i]) {
                    minValue = measureMatrix[j][i];
                }
            }
        }
      
        
        for (int i = 0; i < listZernikeMomentVectors.size(); i++) {
            for (int j = i; j < listZernikeMomentVectors.size(); j++) {
                measureMatrix[j][i] = measureMatrix[i][j] = 1 - (measureMatrix[i][j]/maxValue);
               
            }
        }

        return measureMatrix;
    }
}
