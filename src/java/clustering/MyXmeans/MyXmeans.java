/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clustering.MyXmeans;

import clustering.Clustering;
import distance.AbstractDissimilarity;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;
import matrix.distancematrix.DistanceMatrix;
import matrix.pointsmatrix.AbstractMatrix;
import matrix.pointsmatrix.AbstractVector;
import matrix.pointsmatrix.MatrixFactory;
import matrix.pointsmatrix.MatrixUtils;

/**
 *
 * @author aurea
 */
public class MyXmeans extends Clustering {

    private static final double LOG2PI = Math.log(Math.PI * 2.0);

    public MyXmeans(int maxClusters) {
        super(maxClusters);
        this.medoids = new int[maxClusters];
    }

    @Override
    public ArrayList<ArrayList<Integer>> execute(AbstractDissimilarity diss, AbstractMatrix matrix) throws IOException {
  
        int n = matrix.getRowCount();
        int d = matrix.getDimensions();

        int k = 1;
        int[] size = new int[k];
        size[0] = n;
        int[] y = new int[n];
        centroidsXmeans = new double[k][d];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < d; j++) {
                centroidsXmeans[0][j] += matrix.getRow(i).getValues()[j];
            }
        }

        for (int j = 0; j < d; j++) {
            centroidsXmeans[0][j] /= n;
        }

        // within-cluster sum of squares
        double[] wcss = new double[k];
        for (int i = 0; i < n; i++) {
            wcss[0] += squaredDistance(convertFloatVectorToDoubleVector(matrix.getRow(i).getValues()), centroidsXmeans[0]);
        }

        double distortion = wcss[0];

        BBDTree bbd = new BBDTree(convertFloatMatrixToDoubleMatrix(matrix.toMatrix()));
        while (k < this.maxClusters) {
            ArrayList<double[]> centers = new ArrayList<>();
            double[] score = new double[k];
            KMeans[] kmeans = new KMeans[k];

            for (int i = 0; i < k; i++) {
                // don't split too small cluster. anyway likelihood estimation
                // not accurate in this case.
                if (size[i] < 25) {
                    continue;
                }

                double[][] subset = new double[size[i]][];
                for (int j = 0, l = 0; j < n; j++) {
                    if (y[j] == i) {
                        subset[l++] = convertFloatVectorToDoubleVector(matrix.getRow(j).getValues());
                    }
                }

                kmeans[i] = new KMeans(subset, 2, 100, 4);
                double newBIC = bic(2, size[i], d, kmeans[i].distortion, kmeans[i].size);
                double oldBIC = bic(size[i], d, wcss[i]);
                score[i] = newBIC - oldBIC;
            }

            int[] index = QuickSort.sort(score);
            for (int i = 0; i < k; i++) {
                if (score[index[i]] <= 0.0) {
                    centers.add(centroidsXmeans[index[i]]);
                }
            }

            int m = centers.size();
            for (int i = k; --i >= 0;) {
                if (score[i] > 0) {
                    if (centers.size() + i - m + 1 < maxClusters) {
                        centers.add(kmeans[index[i]].centroids[0]);
                        centers.add(kmeans[index[i]].centroids[1]);
                    } else {
                        centers.add(centroidsXmeans[index[i]]);
                    }
                }
            }

            // no more split.
            if (centers.size() == k) {
                break;
            }

            k = centers.size();
            double[][] sums = new double[k][d];
            size = new int[k];
            centroidsXmeans = new double[k][];
            for (int i = 0; i < k; i++) {
                centroidsXmeans[i] = centers.get(i);
            }

            distortion = Double.MAX_VALUE;
            for (int iter = 0; iter < 100; iter++) {
                double newDistortion = bbd.clustering(centroidsXmeans, sums, size, y);
                for (int i = 0; i < k; i++) {
                    if (size[i] > 0) {
                        for (int j = 0; j < d; j++) {
                            centroidsXmeans[i][j] = sums[i][j] / size[i];
                        }
                    }
                }

                if (distortion <= newDistortion) {
                    break;
                } else {
                    distortion = newDistortion;
                }
            }

            wcss = new double[k];
            for (int i = 0; i < n; i++) {
                wcss[y[i]] += squaredDistance(convertFloatVectorToDoubleVector(matrix.getRow(i).getValues()), centroidsXmeans[y[i]]);
            }

        }
        
        
        ArrayList<ArrayList<Integer>> listClusters = new ArrayList<ArrayList<Integer>> ();
        
        for(int intClus=0; intClus< k;intClus++)
        {
            listClusters.add(new ArrayList<Integer>());
        }
         for(int intMemb=0; intMemb<y.length;intMemb++)
        {
            listClusters.get(y[intMemb]).add(intMemb+1);
        }
        return listClusters;
    }

    @Override
    public ArrayList<ArrayList<Integer>> execute(DistanceMatrix dmat) throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public AbstractMatrix getCentroids() {
        return this.centroids;
    }

    public int[] getMedoids(AbstractMatrix matrix) throws IOException {
        int[] m = new int[this.centroids.getRowCount()];

        for (int i = 0; i < m.length; i++) {
            int point = -1;
            float distance = Float.MAX_VALUE;

            for (int j = 0; j < this.clusters.get(i).size(); j++) {
                float distance2 = this.diss.calculate(this.centroids.getRow(i),
                        matrix.getRow(this.clusters.get(i).get(j)));

                if (distance > distance2) {
                    point = this.clusters.get(i).get(j);
                    distance = distance2;
                }
            }

            m[i] = point;
        }

        return m;
    }

    /**
     * Calculates the BIC for single cluster.
     *
     * @param n the total number of samples.
     * @param d the dimensionality of data.
     * @param distortion the distortion of clusters.
     * @return the BIC score.
     */
    private double bic(int n, int d, double distortion) {
        double variance = distortion / (n - 1);

        double p1 = -n * LOG2PI;
        double p2 = -n * d * Math.log(variance);
        double p3 = -(n - 1);
        double L = (p1 + p2 + p3) / 2;

        int numParameters = d + 1;
        return L - 0.5 * numParameters * Math.log(n);
    }

    /**
     * Calculates the BIC for the given set of centers.
     *
     * @param k the number of clusters.
     * @param n the total number of samples.
     * @param d the dimensionality of data.
     * @param distortion the distortion of clusters.
     * @param clusterSize the number of samples in each cluster.
     * @return the BIC score.
     */
    private double bic(int k, int n, int d, double distortion, int[] clusterSize) {
        double variance = distortion / (n - k);

        double L = 0.0;
        for (int i = 0; i < k; i++) {
            L += logLikelihood(k, n, clusterSize[i], d, variance);
        }

        int numParameters = k + k * d;
        return L - 0.5 * numParameters * Math.log(n);
    }

    /**
     * Estimate the log-likelihood of the data for the given model.
     *
     * @param k the number of clusters.
     * @param n the total number of samples.
     * @param ni the number of samples belong to this cluster.
     * @param d the dimensionality of data.
     * @param variance the estimated variance of clusters.
     * @return the likelihood estimate
     */
    private static double logLikelihood(int k, int n, int ni, int d, double variance) {
        double p1 = -ni * LOG2PI;
        double p2 = -ni * d * Math.log(variance);
        double p3 = -(ni - k);
        double p4 = ni * Math.log(ni);
        double p5 = -ni * Math.log(n);
        double loglike = (p1 + p2 + p3) / 2 + p4 + p5;
        return loglike;
    }

    private static double[] convertFloatVectorToDoubleVector(float[] floatVector) {
        final double[] doubleVector = new double[floatVector.length];

        for (int i = 0; i < floatVector.length; i++) {
            doubleVector[i] = floatVector[i];  // no casting needed
        }
        return doubleVector;
    }

    private static double[][] convertFloatMatrixToDoubleMatrix(float[][] floatMatrix) {
        final double[][] doubleMatrix = new double[floatMatrix.length][floatMatrix[0].length];

        for (int i = 0; i < floatMatrix.length; i++) {
            for (int j = 0; j < floatMatrix[i].length; j++) {
                doubleMatrix[i][j] = floatMatrix[i][j];  // no casting needed
            }
        }
        return doubleMatrix;
    }

    private static double squaredDistance(double[] a, double[] b) {
        double diff_square_sum = 0.0;
        for (int i = 0; i < a.length; i++) {
            diff_square_sum += (a[i] - b[i]) * (a[i] - b[i]);
        }
        return Math.sqrt(diff_square_sum);
    }

    @Override
    public ArrayList<ArrayList<Integer>> getListClusters() {
        return clusters;
    }
    private int maxClusters;
    private ArrayList<ArrayList<Integer>> clusters = new ArrayList<>();
    private AbstractMatrix centroids;
    private double[][] centroidsXmeans;
    protected AbstractDissimilarity diss;
    private final int[] medoids;
    protected static final float EPSILON = 0.00001f;
    protected int nrIterations = 100;

}
