/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.util.ArrayList;

/**
 *
 * @author aurea
 */
public class Operations {

    public static double mean(double[] vector) {

        double sum = 0.f;
        for (int i = 0; i < vector.length; i++) {
            sum += vector[i];
        }
        return sum / vector.length;
    }

    public static double euclideanTwoVectors(ArrayList<Double> vector1, ArrayList<Double> vector2) {
        double euclidean = 0.f;
        for (int i = 0; i < vector1.size(); i++) {
            euclidean += Math.pow((vector1.get(i) - vector2.get(i)), 2);
        }

        return Math.abs(euclidean);
    }

    /**
     * sqrt ( 1/(N-1) SUM_i (x(i) - mean(x))^2 )
     *
     * @param vector1
     * @return
     */
    public static double standarddeviation(double[] vector1) {
        double mean = mean(vector1);
        double std = 0.f;
        for (int i = 0; i < vector1.length; i++) {
            std += Math.pow(vector1[i] - mean, 2);
        }
        return Math.sqrt(std / (vector1.length - 1));

    }

    /**
     * cov (x) = 1/N-1 * SUM_i (x(i) - mean(x)) * (y(i) - mean(y))
     *
     * @param vector1
     * @param vector2
     * @param mean1
     * @return
     */
    public static double covariance(double[] vector1, double[] vector2, double mean1) {

        double cov = 0.f;
        for (int i = 0; i < vector1.length; i++) {
            cov += (vector1[i] - mean1) * (vector2[i] - mean(vector2));
        }
        return cov / (vector1.length - 1);
    }

    /**
     * cov (x) = 1/N-1 * SUM_i (x(i) - mean(x)) * (y(i) - mean(y))
     *
     * @param vector1
     * @param vector2
     * @return
     */
    public static double covariance(double[] vector1, double[] vector2) {

        double cov = 0.f;
        for (int i = 0; i < vector1.length; i++) {
            cov += (vector1[i] - mean(vector1)) * (vector2[i] - mean(vector2));
        }
        return cov / (vector1.length - 1);
    }

    /**
     * corr (x,y) = cov (x,y) / (std (x) * std (y))
     *
     * @param vector1
     * @param vector2
     * @return
     */
    public static double pearson(double[] vector1, double[] vector2) {
        return covariance(vector1, vector2) / (standarddeviation(vector1) * standarddeviation(vector2));

    }

    /**
     * corr (x,y) = cov (x,y) / (std (x) * std (y))
     *
     * @param vector1
     * @param vector2
     * @return
     */
    public static double pearson(ArrayList<Integer> list1, ArrayList<Integer> list2) {
        double[] vector1 = new double[list1.size()];
        double[] vector2 = new double[list2.size()];
        for (int i = 0; i < list1.size(); i++) {
            vector1[i] = list1.get(i);
        }
        for (int i = 0; i < list2.size(); i++) {
            vector2[i] = list2.get(i);
        }
        return covariance(vector1, vector2) / (standarddeviation(vector1) * standarddeviation(vector2));

    }

    /**
     * corr (x,y) = cov (x,y) / (std (x) * std (y))
     *
     * @param vector1
     * @param vector2
     * @return
     */
    public static double pearsonDouble(ArrayList<Double> list1, ArrayList<Double> list2) {
        double[] vector1 = new double[list1.size()];
        double[] vector2 = new double[list2.size()];
        for (int i = 0; i < list1.size(); i++) {
            vector1[i] = list1.get(i);
        }
        for (int i = 0; i < list2.size(); i++) {
            vector2[i] = list2.get(i);
        }
        return covariance(vector1, vector2) / (standarddeviation(vector1) * standarddeviation(vector2));

    }

    public static double mean(double[][] matrix) {

        double sum = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                if (value > -1.0) {
                    sum += value;
                    count++;
                }
            }
        }

        if (count == 0) {
            return sum / 0.001;
        }
        return sum / count;

    }

    public static double meanMoment(double[][] matrix) {

        double sum = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                if (value > -1.0) {
                    sum += value;
                    count++;
                }
            }
        }

        if (count == 0) {
            return sum / 0.001;
        }
        return sum / count;

    }

    /**
     * sqrt ( 1/(N-1) SUM_i (x(i) - mean(x))^2 )
     *
     * @param matrix
     * @return
     */
    public static double standarddeviation(double[][] matrix) {
        double mean = mean(matrix);
        double std = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                if (value > -1.0) {
                    std += Math.pow(value - mean, 2);
                    count++;
                }
            }
        }
        if ((count - 1) == 0) {
            return Math.sqrt(std / 0.001);
        }
        return Math.sqrt(std / (count - 1));

    }

    /**
     * sqrt ( 1/(N-1) SUM_i (x(i) - mean(x))^2 )
     *
     * @param matrix
     * @return
     */
    public static double standarddeviationMoment(double[][] matrix) {
        double mean = meanMoment(matrix);
        double std = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                if (value > -1.0) {
                    std += Math.pow(value - mean, 2);
                    count++;
                }
            }
        }
        if ((count - 1) == 0) {
            return Math.sqrt(std / 0.001);
        }
        return Math.sqrt(std / (count - 1));

    }

    /**
     * 1/(N-1) SUM_i (x(i) - mean(x))^2
     *
     * @param matrix
     * @return
     */
    public static double variance(double[][] matrix) {
        double mean = mean(matrix);
        double var = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                var += Math.pow(matrix1[j] - mean, 2);
                count++;
            }
        }
        if ((count - 1) == 0) {
            return var / 0.001;
        }
        return var / (count - 1);

    }

    /**
     * cubic root ( 1/(N-1) SUM_i (x(i) - mean(x))^3 )
     *
     * @param matrix
     * @return
     */
    public static double skewness(double[][] matrix, double std) {
        double mean = mean(matrix);
        double skew = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                skew += (Math.pow((matrix1[j] - mean) / std, 3));
                count++;
            }
        }
        if ((count) == 0) {
            return Math.cbrt(skew / (0.001));
        }
        return Math.cbrt(skew / (count));

    }

    /**
     * cubic root ( 1/(N-1) SUM_i (x(i) - mean(x))^3 )
     *
     * @param matrix
     * @return
     */
    public static double skewnessMoment(double[][] matrix, double std) {
        double mean = meanMoment(matrix);
        double skew = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                if (value > -1.0) {
                    skew += (Math.pow((value - mean) / std, 3));
                    count++;
                }
            }
        }
        if ((count) == 0) {
            return Math.cbrt(skew / (0.001));
        }
        return Math.cbrt(skew / (count));

    }

    /**
     * 4 root ( 1/(N-1) SUM_i (x(i) - mean(x))^4 )
     *
     * @param matrix
     * @return
     */
    public static double kurtosis(double[][] matrix, double std) {
        double mean = mean(matrix);
        double kurtosis = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                kurtosis += (Math.pow((matrix1[j] - mean) / std, 4));
                count++;
            }
        }
        if ((count) == 0) {
            return 0.0;
        }
        return Math.pow((kurtosis / (count)), 1 / 4);

    }

    /**
     * 4 root ( 1/(N-1) SUM_i (x(i) - mean(x))^4 )
     *
     * @param matrix
     * @return
     */
    public static double kurtosisMoment(double[][] matrix, double std) {
        double mean = meanMoment(matrix);
        double kurtosis = 0.f;
        int count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                if (value > -1.0) {
                    kurtosis += (Math.pow((value - mean) / std, 4));
                    count++;
                }
            }
        }
        if ((count) == 0) {
            return 0.0;
        }
        return Math.pow((kurtosis / (count)), 1 / 4);

    }

    /**
     * cov (x) = 1/N-1 * SUM_i (x(i) - mean(x)) * (y(i) - mean(y))
     *
     * @param matrix1
     * @param matrix2
     * @return
     */
    public static double covariance(double[][] matrix1, double[][] matrix2) {

        double cov = 0.f;
        int count = 0;
        double mean1 = mean(matrix1);
        double mean2 = mean(matrix2);
        for (int i = 0; i < matrix1.length; i++) {
            for (int j = 0; j < matrix1[i].length; j++) {
                if (matrix1[i][j] > -1 &&  matrix2[i][j]>-1) {
                    cov += (((int) matrix1[i][j] * 1.0) - mean1) * (((int) matrix2[i][j] * 1.0) - mean2);
                    count++;
                }
            }
        }

        if ((count - 1) == 0) {
            return cov / 0.0001;
        }
        return cov / (count - 1);

    }

    /**
     * corr (x,y) = cov (x,y) / (std (x) * std (y))
     *
     * @param matrix1
     * @param matrix2
     * @return
     */
    public static double pearson(double[][] matrix1, double[][] matrix2) {
        return covariance(matrix1, matrix2) / (standarddeviation(matrix1) * standarddeviation(matrix2));

    }

    /**
     * corr (x,y) = cov (x,y) / (std (x) * std (y))
     *
     * @param vector1
     * @param vector2
     * @param std1
     * @param mean1
     * @return
     */
    public static double pearson(double[] vector1, double[] vector2, double std1, double mean1) {
        return covariance(vector1, vector2, mean1) / (std1 * standarddeviation(vector2));

    }

    public static int factorial(int n) {
        int fact = 1; // this  will be the result
        for (int i = 1; i <= n; i++) {
            fact *= i;
        }
        return fact;
    }

    public static double radialPolynomial(double rho, int n, int m) {
        double radial = 0.f;
        int limit = (n - Math.abs(m)) / 2;
        for (int s = 0; s < limit; s++) {
            double num = factorial(n - s);
            double x = factorial(s);
            double y = factorial(((n + Math.abs(m)) / 2) - s);
            double z = factorial(((n - Math.abs(m)) / 2) - s);
            double c = (Math.pow(-1, s) * (num / (x * y * z)));
            radial += (c * Math.pow(rho, n - 2 * s));
        }
        return radial;
    }

    public static int distance(float[] p1, float[] p2) {

        float sum = 0;
        for (int i = 0; i < p1.length; i++) {
            sum += Math.abs(p1[i] - p2[i]);
        }
        return (int) sum;
    }

    public static float distance(ArrayList<Integer> p1, ArrayList<Integer> p2) {

        float sum = 0;
        for (int i = 0; i < p1.size(); i++) {
            sum += Math.abs((p1.get(i)) - (p2.get(i)));
        }
        return sum;
    }

    public static float distanceRealityPrediction(ArrayList<Integer> reality, ArrayList<Integer> prediction) {

        float sum = 0;
        for (int i = 0; i < reality.size(); i++) {
            if (reality.get(i) != -1 && prediction.get(i) != -1) {
                sum += Math.abs((reality.get(i)) - (prediction.get(i)));
            }
        }
        return sum;
    }

    public static float percentage(float value, float maxValue) {

        if (maxValue == 0) {
            maxValue = 0.0000001f;
        }
        return value * 100 / maxValue;
    }

    /**
     * 1 original 2 to the new scale
     *
     * @param valueIn
     * @param baseMin
     * @param baseMax
     * @param limitMin
     * @param limitMax
     * @return
     */
    public static Double minmax(Double valueIn, Double baseMin, Double baseMax, Double limitMin, Double limitMax) {
        Double den = (baseMax - baseMin);
        if (den == 0.0) {
            den = 0.000001;
        }

        return ((limitMax - limitMin) * (valueIn - baseMin) / den) + limitMin;
    }

    /**
     * 1 original 2 to the new scale
     *
     * @param valueIn
     * @param baseMin
     * @param baseMax
     * @param limitMin
     * @param limitMax
     * @return
     */
    public static Integer minmax(Integer valueIn, Integer baseMin, Integer baseMax, Integer limitMin, Integer limitMax) {
        Double den = (baseMax - baseMin) * 1.0;
        if (den == 0) {
            den = 0.000001;
        }

        return (int) ((limitMax - limitMin) * (valueIn - baseMin) / den) + limitMin;
    }

    /**
     * 1 original 2 to the new scale
     *
     * @param valueIn
     * @param baseMin
     * @param baseMax
     * @param limitMin
     * @param limitMax
     * @return
     */
    public static Float minmax(Float valueIn, Float baseMin, Float baseMax, Float limitMin, Float limitMax) {
        Float den = (baseMax - baseMin);
        if (den == 0.f) {
            den = 0.000001f;
        }

        return ((limitMax - limitMin) * (valueIn - baseMin) / den) + limitMin;

    }

    /**
     * 1- (standard deviation /mean)
     *
     * @param std
     * @param mean
     * @return
     */
    public static Float uniformity(float std, float mean) {
        float uniformity = 1 - (std / mean);
        return uniformity;

    }

    public static ArrayList<Integer> histogram(double[][] matrix) {
        ArrayList<Integer> histogram = new ArrayList<Integer>();
        for (int i = 0; i < 255; i++) {
            histogram.add(0);
        }
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                int position = ((int) matrix1[j]);
                if (position > -1) {
                    histogram.set(position, histogram.get(position) + 1);
                }
            }

        }
        for (int i = 0; i < histogram.size(); i++) {
            System.out.println("histo " + i + " " + histogram.get(i));
        }
        return histogram;

    }

    /**
     * under construction
     *
     * @param matrix
     * @return
     */
    public static double entropy(double[][] matrix) {
        ArrayList<Integer> histogram = histogram(matrix);
        int size = matrix.length * matrix[0].length;
        double entropyTmp = 0.0;
        for (int i = 0; i < histogram.size(); i++) {
            double pzi = (double) histogram.get(i) / (double) size;
            entropyTmp = entropyTmp + pzi * (double) (Math.log(pzi) / Math.log(2));//log2((double) pzi);
        }
        return -entropyTmp;
    }

    public static int counter(double[][] matrix, double inValue) {
        Integer count = 0;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                if (matrix1[j] == inValue) {
                    count++;
                }
            }
        }
        return count;

    }

    /**
     * Built-in Function: diff (X, K, DIM) If X is a vector of length n, 'diff
     * (X)' is the vector of first differences X(2) - X(1), ..., X(n) - X(n-1).
     *
     * If X is a matrix, 'diff (X)' is the matrix of column differences along
     * the first non-singleton dimension.
     *
     * The second argument K is a non-negative integer, returns the K-th
     * differences. It is possible that K is larger than the first non-singleton
     * dimension of the matrix. In this case, 'diff' continues to take the
     * differences along the next non-singleton dimension.
     *
     * The dimension along which to take the difference can be explicitly stated
     * with the optional variable DIM. In this case the K-th order differences
     * are calculated along this dimension. In the case where K exceeds 'size
     * (X, DIM)' an empty matrix is returned.
     *
     * orientation X k=1
     *
     * @param matrix
     * @param tamX
     * @param tamY
     * @return
     */
    public static double[][] diffX(double[][] matrix) {
        int tamX = matrix[0].length;
        int tamY = matrix.length;

        double[][] diffXMatrix = new double[tamY][tamX - 1];
        for (int i = 0; i < tamY; i++) {
            for (int j = 0; j < tamX - 1; j++) {
                diffXMatrix[i][j] = (matrix[i][j + 1] - matrix[i][j]);

            }
        }
        return diffXMatrix;
    }

    /**
     * Built-in Function: diff (X, K, DIM) If X is a vector of length n, 'diff
     * (X)' is the vector of first differences X(2) - X(1), ..., X(n) - X(n-1).
     *
     * If X is a matrix, 'diff (X)' is the matrix of column differences along
     * the first non-singleton dimension.
     *
     * The second argument K is a non-negative integer, returns the K-th
     * differences. It is possible that K is larger than the first non-singleton
     * dimension of the matrix. In this case, 'diff' continues to take the
     * differences along the next non-singleton dimension.
     *
     * The dimension along which to take the difference can be explicitly stated
     * with the optional variable DIM. In this case the K-th order differences
     * are calculated along this dimension. In the case where K exceeds 'size
     * (X, DIM)' an empty matrix is returned.
     *
     * orientation Y k=1
     *
     * @param matrix
     * @param k
     * @return
     */
    public static double[][] diffY(double[][] matrix) {
        int tamX = matrix[0].length;
        int tamY = matrix.length;

        double[][] diffYMatrix = new double[tamY - 1][tamX];
        for (int i = 0; i < tamY - 1; i++) {
            for (int j = 0; j < tamX; j++) {
                diffYMatrix[i][j] = (matrix[i + 1][j] - matrix[i][j]);

            }
        }
        return diffYMatrix;
    }

    public static double[][] abs(double[][] matrix) {

        double[][] absMatrix = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                absMatrix[i][j] = Math.abs(matrix[i][j]);

            }
        }
        return absMatrix;
    }

    /**
     * Pow of each value
     *
     * @param matrix
     * @param exponent
     * @return
     */
    public static double[][] pow(double[][] matrix, int exponent) {

        double[][] powMatrix = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                powMatrix[i][j] = Math.pow(matrix[i][j], exponent);
            }
        }
        return powMatrix;
    }

    public static double[] fillVectorValuesOrdered(int number) {
        double[] vector = new double[number];

        for (int i = 1; i <= number; i++) {
            vector[i - 1] = 1;
        }
        return vector;
    }

    public static double[][] cleanNaN(double[][] matrix) {
        double[][] sumMatrix = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {

                if (Double.isNaN(matrix[i][j])) {
                    sumMatrix[i][j] = -1;
                } else {
                    sumMatrix[i][j] = matrix[i][j];
                }
            }
        }
        return sumMatrix;
    }

    public static double[][] sumScalarPlusValueMatrix(double[][] matrix, double number) {
        double[][] sumMatrix = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                sumMatrix[i][j] = matrix[i][j] + number;
            }
        }
        return sumMatrix;
    }

    public static double[][] sqrt(double[][] matrix) {

        double[][] sqrtMatrix = new double[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                sqrtMatrix[i][j] = Math.sqrt(matrix[i][j]);
            }
        }
        return sqrtMatrix;
    }

    public static double[] sumInY(double[][] matrix) {

        double[] sumInY = new double[matrix.length];
        for (int i = 0; i < matrix.length; i++) {
            double sum = 0.0;
            for (int j = 0; j < matrix[i].length; j++) {
                sum += matrix[i][j];

            }
            sumInY[i] = sum;
        }
        return sumInY;
    }

    public static double[] sumScalarPlusValueVector(double[] vector, double number) {
        double[] sumVector = new double[vector.length];
        for (int i = 0; i < vector.length; i++) {
            sumVector[i] = sumVector[i] + number;
        }
        return sumVector;
    }

    /**
     * sum all values of a Matrix
     *
     * @param matrix
     * @return
     */
    public static double sumValuesMatrix(double[][] matrix) {
        double sum = 0.f;
        for (double[] matrix1 : matrix) {
            for (int j = 0; j < matrix1.length; j++) {
                double value = ((int) matrix1[j] * 1.0);
                sum += value;
            }
        }
        return sum;
    }

    /**
     * sum all values of a Matrix
     *
     * @param vector
     * @return
     */
    public static double sumValuesVector(double[] vector) {
        double sum = 0.f;
        for (double value : vector) {
            sum += value;
        }
        return sum;
    }

    public static double[] multiplyVectorAndMatrix(double[] vector, double[][] matrix) {

        assert (matrix != null && vector.length == matrix.length) : "Matrix size or vector size with error!";

        /* Matrix-vector product  */
        int cols = matrix[0].length;
        int rows = matrix.length;
        double[] result = new double[cols];
        // matrix product
        double sum = 0;
        for (int j = 0; j < cols; j++) {
            for (int i = 0; i < rows; i++) {
                sum = sum + (matrix[i][j] * vector[i]);
            }
            result[j] = sum;
            sum = 0;
        }
        return result;
    }

    public static double[] multiplyVectorAndMatrix(double[][] matrix, double[] vector) {

        assert (matrix != null && matrix[0].length == vector.length) : "Matrix size or vector size with error!";

        /* Matrix-vector product  */
        double[] result = new double[matrix.length];
        // matrix product
        double sum = 0;
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                sum = sum + (matrix[i][j] * vector[j]);
            }
            result[i] = sum;
            sum = 0;
        }

        return result;

    }

    public static double[][] calculateCorrelationMatrix(double[][] matrix) {

        int numRows = matrix.length;
        double[][] correlationMatrix = new double[numRows][numRows];

        for (int i = 0; i < numRows; i++) {
            for (int j = i; j < numRows; j++) {
                if (i == j) {
                    correlationMatrix[i][i] = 1;
                } else {
                    double[] vector1 = matrix[i];
                    double[] vector2 = matrix[j];
                    double correlation = Operations.pearson(vector1, vector2);
                    correlationMatrix[i][j] = correlation;
                    correlationMatrix[j][i] = correlation;
                }
            }
        }
        return correlationMatrix;
    }

    public static void main(String[] args) {

        /* ArrayList<String> listHours = new ArrayList<>();
         listHours = listDistanceInHours(6, 2, listHours);
         System.out.println(distanceInHours(6, 2));
         System.out.println(listHours.size());
         for (String listHour : listHours) {
         System.out.println(listHour);
         }*/
        System.out.println(minmax(7, 0, 8, 0, 255));
    }
}
