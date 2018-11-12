/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package moments;

import java.util.ArrayList;

/**
 *
 * @author aurea
 */
/**
 * Combined Blur and Affine Moment Invariants. Paper: "Combined blur and affine
 * moment invariants and their use in pattern recognition. Tomas Suk, Jan
 * Flusser" Link:
 * http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.85.7431&rep=rep1&type=pdf
 */
public class FlusserSukMoments {

    /**
     * Initialize a new instance of the FlusserSukMoments class.
     */
    public FlusserSukMoments() {
    }

    /**
     * Compute Blur and Affine moment invariants.
     *
     * @param double[][] matrix to be processed.
     * @return 6 Moments.
     */
    public double[] Compute(double[][] matrix) {

        ArrayList<Integer> i = new ArrayList<>();
        ArrayList<Integer> j = new ArrayList<>();
        FindNonZero(matrix, i, j);

        double[] x = Convert(i);
        double[] y = Convert(j);

        double m00 = Sum(matrix);

        x = Normalize(x, matrix, m00);
        y = Normalize(y, matrix, m00);

        // Second order central moments
        double m20 = CentralMoments(x, y, 2, 0, matrix);
        double m02 = CentralMoments(x, y, 0, 2, matrix);
        double m11 = CentralMoments(x, y, 1, 1, matrix);

        // Third order central moments
        double m30 = CentralMoments(x, y, 3, 0, matrix);
        double m03 = CentralMoments(x, y, 0, 3, matrix);
        double m21 = CentralMoments(x, y, 2, 1, matrix);
        double m12 = CentralMoments(x, y, 1, 2, matrix);

        // Fouth order central moments
        double m40 = CentralMoments(x, y, 4, 0, matrix);
        double m04 = CentralMoments(x, y, 0, 4, matrix);
        double m31 = CentralMoments(x, y, 3, 1, matrix);
        double m13 = CentralMoments(x, y, 1, 3, matrix);
        double m22 = CentralMoments(x, y, 2, 2, matrix);

        // Fifth order central moments
        double m50 = CentralMoments(x, y, 5, 0, matrix);
        double m05 = CentralMoments(x, y, 0, 5, matrix);
        double m41 = CentralMoments(x, y, 4, 1, matrix);
        double m14 = CentralMoments(x, y, 1, 4, matrix);
        double m32 = CentralMoments(x, y, 3, 2, matrix);
        double m23 = CentralMoments(x, y, 2, 3, matrix);

        // Seventh order central moments
        double m70 = CentralMoments(x, y, 7, 0, matrix);
        double m07 = CentralMoments(x, y, 0, 7, matrix);
        double m16 = CentralMoments(x, y, 1, 6, matrix);
        double m61 = CentralMoments(x, y, 6, 1, matrix);
        double m52 = CentralMoments(x, y, 5, 2, matrix);
        double m25 = CentralMoments(x, y, 2, 5, matrix);
        double m43 = CentralMoments(x, y, 4, 3, matrix);
        double m34 = CentralMoments(x, y, 3, 4, matrix);

        // For blur invariance we recompute certain values
        m50 = m50 - (10 * m30 * m20 / m00);
        m41 = m41 - (2 * (3 * m21 * m20 + 2 * m30 * m11) / m00);
        m32 = m32 - ((3 * m12 * m20 + m30 * m02 + 6 * m21 * m11) / m00);
        m23 = m23 - ((3 * m21 * m02 + m03 * m20 + 6 * m12 * m11) / m00);
        m14 = m14 - (2 * (3 * m12 * m02 + 2 * m03 * m11) / m00);
        m05 = m05 - (10 * m03 * m02 / m00);

        // For blur invariance seventh order moments recomputed
        m70 = m70 - 7 * (3 * m50 * m20 + 5 * m30 * m40) / m00 + (210 * m30 * (m20 * m20) / (m00 * m00));

        m61 = m61 - (6 * m50 * m11 + 15 * m41 * m20 + 15 * m40 * m21 + 20 * m31 * m30) / m00
                + 30 * (3 * m21 * (m20 * m20) + 4 * m30 * m20 * m11) / (m00 * m00);

        m52 = m52 - (m50 * m02 + 10 * m30 * m22 + 10 * m32 * m20 + 20 * m31 * m21 + 10 * m41 * m11 + 5 * m40 * m12) / m00
                + 10 * (3 * m12 * (m20 * m20) + 2 * m30 * m20 * m02 + 4 * m30 * (m11 * m11) + 12 * m21 * m20 * m11) / (m00 * m00);

        m43 = m43 - (m40 * m03 + 18 * m21 * m22 + 12 * m31 * m12 + 4 * m30 * m13 + 3 * m41 * m02 + 12 * m32 * m11
                + 6 * m23 * m20) / m00 + 6 * (m03 * (m20 * m20) + 4 * m30 * m11 * m02 + 12 * m21 * (m11 * m11) + 12 * m12 * m20 * m11 + 6 * m21 * m02 * m20);

        m34 = m34 - (m04 * m30 + 18 * m12 * m22 + 12 * m13 * m21 + 4 * m03 * m31 + 3 * m14 * m20 + 12 * m23 * m11
                + 6 * m32 * m02) / m00 + 6 * (m30 * (m02 * m02) + 4 * m03 * m11 * m20 + 12 * m12 * (m11 * m11) + 12 * m21 * m02 * m11
                + 6 * m12 * m20 * m02) / (m00 * m00);

        m25 = m25 - (m05 * m20 + 10 * m03 * m22 + 10 * m23 * m02 + 20 * m13 * m12 + 10 * m14 * m11 + 5 * m04 * m21) / m00
                + 10 * (3 * m21 * (m02 * m02) + 2 * m03 * m02 * m20 + 4 * m03 * (m11 * m11) + 12 * m12 * m02 * m11) / (m00 * m00);

        m16 = m16 - (6 * m05 * m11 + 15 * m14 * m02 + 15 * m04 * m12 + 20 * m13 * m03) / m00 + 30 * (3 * m12 * (m02 * m02)
                + 4 * m03 * m02 * m11) / (m00 * m00);

        m07 = m07 - 7 * (3 * m05 * m02 + 5 * m03 * m04) / m00 + (210 * m03 * (m02 * m02) / (m00 * m00));

        //First invariant computed from the determinant of the polynomial
        double I1 = ((m30 * m30) * (m03 * m03) - 6 * m30 * m21 * m12 * m03 + 4 * m30 * (m12 * m12 * m12)
                + 4 * (m21 * m21 * m21) * m03 - 3 * (m21 * m21) * (m12 * m12)) / Math.pow(m00, 10);

        double I2 = ((m50 * m50) * (m05 * m05) - 10 * m50 * m41 * m14 * m05 + 4 * m50 * m32 * m23 * m05
                + 16 * m50 * m32 * (m14 * m14) - 12 * m50 * (m23 * m23) * m14 + 16 * (m41 * m41) * m23 * m05
                + 9 * (m41 * m41) * (m14 * m14) - 12 * m41 * (m32 * m32) * m05 - 76 * m41 * m32 * m23 * m14
                + 48 * m41 * (m23 * m23 * m23) + 48 * (m32 * m32 * m32) * m14 - 32 * (m32 * m32) * (m23 * m23)) / Math.pow(m00, 14);

        double I3 = ((m30 * m30) * m12 * m05 - (m30 * m30) * m03 * m14 - m30 * (m21 * m21) * m05 - 2 * m30 * m21 * m12 * m14
                + 4 * m30 * m21 * m03 * m23 + 2 * m30 * (m12 * m12) * m23 - 4 * m30 * m12 * m03 * m32
                + m30 * (m03 * m03) * m41 + 3 * (m21 * m21 * m21) * m14 - 6 * (m21 * m21) * m12 * m23 - 2 * (m21 * m21) * m03 * m32
                + 6 * m21 * (m12 * m12) * m32 + 2 * m21 * m12 * m03 * m41 - m21 * (m03 * m03) * m50 - 3 * (m12 * m12 * m12) * m41
                + (m12 * m12) * m03 * m50) / Math.pow(m00, 11);

        double I4 = (2 * m30 * m12 * m41 * m05 - 8 * m30 * m12 * m32 * m14 + 6 * m30 * m12 * (m23 * m23)
                - m30 * m03 * m50 * m05 + 3 * m30 * m03 * m41 * m14 - 2 * m30 * m03 * m32 * m23
                - 2 * (m21 * m21) * m41 * m05 + 8 * (m21 * m21) * m32 * m14 - 6 * (m21 * m21) * (m23 * m23)
                + m21 * m12 * m50 * m05 - 3 * m21 * m12 * m41 * m14 + 2 * m21 * m12 * m32 * m23
                + 2 * m21 * m03 * m50 * m14 - 8 * m21 * m03 * m41 * m23 + 6 * m21 * m03 * (m32 * m32)
                - 2 * (m12 * m12) * m50 * m14 + 8 * (m12 * m12) * m41 * m23 - 6 * (m12 * m12) * (m32 * m32)) / Math.pow(m00, 12);

        double I5 = (m30 * m41 * m23 * m05 - m30 * m41 * (m14 * m14) - m30 * (m32 * m32) * m05 + 2 * m30 * m32 * m23 * m14
                - m30 * (m23 * m23 * m23) - m21 * m50 * m23 * m05 + m21 * m50 * (m14 * m14) + m21 * m41 * m32 * m05
                - m21 * m41 * m23 * m14 - m21 * (m32 * m32) * m14 + m21 * m32 * (m23 * m23) + m12 * m50 * m32 * m05
                - m12 * m50 * m23 * m14 - m12 * (m41 * m41) * m05 + m12 * m41 * m32 * m14 + m12 * m41 * (m23 * m23)
                - m12 * (m32 * m32) * m23 - m03 * m50 * m32 * m14 + m03 * m50 * (m23 * m23)
                + m03 * (m41 * m41) * m14 - 2 * m03 * m41 * m32 * m23 + m03 * (m32 * m32 * m32)) / Math.pow(m00, 13);

        double I6 = ((m70 * m70) * (m07 * m07) - 14 * m70 * m61 * m16 * m07 + 18 * m70 * m52 * m25 * m07 + 24 * m70 * m52 * (m16 * m16)
                - 10 * m70 * m43 * m34 * m07 - 60 * m70 * m43 * m25 * m16 + 40 * m70 * (m34 * m34) * m16 + 24 * (m61 * m61) * m25 * m07
                + 25 * (m61 * m61) * (m16 * m16) - 60 * m61 * m52 * m34 * m07 - 234 * m61 * m52 * m25 * m16 + 40 * m61 * (m43 * m43) * m07
                + 50 * m61 * m43 * m34 * m16 + 360 * m61 * m43 * (m25 * m25) - 240 * m61 * (m34 * m34) * m25 + 360 * (m52 * m52) * m34 * m16
                + 81 * (m52 * m52) * (m25 * m25) - 240 * m52 * (m43 * m43) * m16 - 990 * m52 * m43 * m34 * m25 + 600 * m52 * (m34 * m34 * m34)
                + 600 * (m43 * m43 * m43) * m25 - 375 * (m43 * m43) * (m34 * m34)) / Math.pow(m00, 18);

        double[] moments = new double[6];
        moments[0] = I1;
        moments[1] = I2;
        moments[2] = I3;
        moments[3] = I4;
        moments[4] = I5;
        moments[5] = I6;

        return moments;

    }

    private void FindNonZero(double[][] matrix, ArrayList<Integer> x, ArrayList<Integer> y) {

        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                if (matrix[i][j] > -1) {
                    x.add(i + 1);
                    y.add(j + 1);
                }
            }
        }
    }

    private double[] Convert(ArrayList<Integer> lst) {

        double[] val = new double[lst.size()];
        for (int i = 0; i < lst.size(); i++) {
            val[i] = lst.get(i);
        }
        return val;
    }

    private double Sum(double[][] matrix) {

        double sum = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                sum += ((int)matrix1[j]*1.0+1);
            }
        }
        return sum;

    }

    private double[] Normalize(double[] val, double[][] matrix, double m00) {

        double sum = 0;
        int k = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                if (matrix1[j] > -1) {
                    sum += val[k] * ((int)matrix1[j]*1.0+1);
                    k++;
                }
            }
        }

        for (int i = 0; i < val.length; i++) {
            val[i] -= sum / m00;
        }

        return val;

    }

    private double CentralMoments(double[] x, double[] y, int p, int q, double[][] matrix) {

        double sum = 0;
        int k = 0;
          for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                if (matrix1[j] > -1) {
                    sum += (Math.pow(x[k], p) * Math.pow(y[k], q) * ((int)matrix1[j]*1.0+1));
                    k++;
                }
            }
        }

        return sum;
    }
}
