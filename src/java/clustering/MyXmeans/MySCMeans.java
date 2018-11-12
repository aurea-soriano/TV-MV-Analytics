/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clustering.MyXmeans;

import clustering.Clustering;
import clustering.SilhouetteCoefficient;
import distance.AbstractDissimilarity;
import distance.EuclideanSimilarity;
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
public class MySCMeans extends Clustering {

    private static final double LOG2PI = Math.log(Math.PI * 2.0);

    public MySCMeans(int maxClusters) {
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
                score[i] = silhouetteCoefficient(kmeans[i].y, matrix);
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

        ArrayList<ArrayList<Integer>> listClusters = new ArrayList<ArrayList<Integer>>();

        for (int intClus = 0; intClus < k; intClus++) {
            listClusters.add(new ArrayList<Integer>());
        }
        for (int intMemb = 0; intMemb < y.length; intMemb++) {
            listClusters.get(y[intMemb]).add(intMemb + 1);
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

    public double silhouetteCoefficient(int[] y, AbstractMatrix matrix) throws IOException {

        for (int i = 0; i < y.length; i++) {
            matrix.getRow(i).setKlass(y[i]);
        }
        SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
        float[] silhouetteCoefficients = silhouetteCoefficient.execute(matrix, new EuclideanSimilarity());
        return silhouetteCoefficient.average(silhouetteCoefficients);
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
