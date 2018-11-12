/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

/**
 *
 * @author aurea
 */
public class VectorOperation {

    public static float[] sum(float[] A, float[] B) {
        if (A.length != B.length) {
            throw new RuntimeException("Illegal vector dimensions.");
        }
        float[] result = new float[B.length];

        for (int i = 0; i < B.length; i++) {

            result[i] = A[i] + B[i];

        }

        return result;
    }
    
      public static float[] substraction(float[] A, float[] B) {
        if (A.length != B.length) {
            throw new RuntimeException("Illegal vector dimensions.");
        }
        float[] result = new float[B.length];

        for (int i = 0; i < B.length; i++) {

            result[i] = A[i] - B[i];

        }

        return result;
    }
}
