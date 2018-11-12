/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clustering.MyXmeans;

/**
 *
 * @author aurea
 */
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.Callable;
import java.util.concurrent.ForkJoinPool;

/**
 * Abstract class of partition clustering. Partition methods break the
 * observation into distinct non-overlapping groups.
 *
 * @param <T> the type of input object.
 *
 * @author Haifeng Li
 */
public abstract class PartitionClustering<T> implements Clustering<T> {

    /**
     * The number of clusters.
     */
    protected int k;
    /**
     * The cluster labels of data.
     */
    protected int[] y;
    /**
     * The number of samples in each cluster.
     */
    protected int[] size;

    /**
     * Returns the number of clusters.
     */
    public int getNumClusters() {
        return k;
    }

    /**
     * Returns the cluster labels of data.
     */
    public int[] getClusterLabel() {
        return y;
    }

    /**
     * Returns the size of clusters.
     */
    public int[] getClusterSize() {
        return size;
    }

    /**
     * Squared Euclidean distance with handling missing values (represented as
     * NaN).
     */
    static double squaredDistance(double[] x, double[] y) {
        int n = x.length;
        int m = 0;
        double dist = 0.0;

        for (int i = 0; i < n; i++) {
            if (!Double.isNaN(x[i]) && !Double.isNaN(y[i])) {
                m++;
                double d = x[i] - y[i];
                dist += d * d;
            }
        }

        if (m == 0) {
            dist = Double.MAX_VALUE;
        } else {
            dist = n * dist / m;
        }

        return dist;
    }

    /**
     * Initialize cluster membership of input objects with KMeans++ algorithm.
     * Many clustering methods, e.g. k-means, need a initial clustering
     * configuration as a seed.
     * <p>
     * K-Means++ is based on the intuition of spreading the k initial cluster
     * centers away from each other. The first cluster center is chosen
     * uniformly at random from the data points that are being clustered, after
     * which each subsequent cluster center is chosen from the remaining data
     * points with probability proportional to its distance squared to the
     * point's closest cluster center.
     * <p>
     * The exact algorithm is as follows:
     * <ol>
     * <li> Choose one center uniformly at random from among the data points.
     * </li>
     * <li> For each data point x, compute D(x), the distance between x and the
     * nearest center that has already been chosen. </li>
     * <li> Choose one new data point at random as a new center, using a
     * weighted probability distribution where a point x is chosen with
     * probability proportional to D<sup>2</sup>(x). </li>
     * <li> Repeat Steps 2 and 3 until k centers have been chosen. </li>
     * <li> Now that the initial centers have been chosen, proceed using
     * standard k-means clustering. </li>
     * </ol>
     * This seeding method gives out considerable improvements in the final
     * error of k-means. Although the initial selection in the algorithm takes
     * extra time, the k-means part itself converges very fast after this
     * seeding and thus the algorithm actually lowers the computation time too.
     *
     * <h2>References</h2>
     * <ol>
     * <li> D. Arthur and S. Vassilvitskii. "K-means++: the advantages of
     * careful seeding". ACM-SIAM symposium on Discrete algorithms, 1027-1035,
     * 2007.</li>
     * <li> Anna D. Peterson, Arka P. Ghosh and Ranjan Maitra. A systematic
     * evaluation of different methods for initializing the K-means clustering
     * algorithm. 2010.</li>
     * </ol>
     *
     * @param data data objects to be clustered.
     * @param k the number of cluster.
     * @return the cluster labels.
     */
    public static int[] seed(double[][] data, int k, ClusteringDistance distance) {
        int n = data.length;
        int[] y = new int[n];
        double[] centroid = data[randomInt(n)];

        double[] d = new double[n];
        for (int i = 0; i < n; i++) {
            d[i] = Double.MAX_VALUE;
        }

        // pick the next center
        for (int j = 1; j < k; j++) {
            // Loop over the samples and compare them to the most recent center.  Store
            // the distance from each sample to its closest center in scores.
            for (int i = 0; i < n; i++) {
                // compute the distance between this sample and the current center
                double dist = 0.0;
                switch (distance) {
                    case EUCLIDEAN:
                        dist = squaredDistance(data[i], centroid);
                        break;
                    case EUCLIDEAN_MISSING_VALUES:
                        dist = squaredDistance(data[i], centroid);
                        break;
                    case JENSEN_SHANNON_DIVERGENCE:
                        dist = JensenShannonDivergence(data[i], centroid);
                        break;
                }

                if (dist < d[i]) {
                    d[i] = dist;
                    y[i] = j - 1;
                }
            }

            double cutoff = Math.random() * sum(d);
            double cost = 0.0;
            int index = 0;
            for (; index < n; index++) {
                cost += d[index];
                if (cost >= cutoff) {
                    break;
                }
            }

            centroid = data[index];
        }

        for (int i = 0; i < n; i++) {
            // compute the distance between this sample and the current center
            double dist = 0.0;
            switch (distance) {
                case EUCLIDEAN:
                    dist = squaredDistance(data[i], centroid);
                    break;
                case EUCLIDEAN_MISSING_VALUES:
                    dist = squaredDistance(data[i], centroid);
                    break;
                case JENSEN_SHANNON_DIVERGENCE:
                    dist = JensenShannonDivergence(data[i], centroid);
                    break;
            }

            if (dist < d[i]) {
                d[i] = dist;
                y[i] = k - 1;
            }
        }

        return y;
    }

    /**
     * Initialize cluster membership of input objects with KMeans++ algorithm.
     * Many clustering methods, e.g. k-means, need a initial clustering
     * configuration as a seed.
     * <p>
     * K-Means++ is based on the intuition of spreading the k initial cluster
     * centers away from each other. The first cluster center is chosen
     * uniformly at random from the data points that are being clustered, after
     * which each subsequent cluster center is chosen from the remaining data
     * points with probability proportional to its distance squared to the
     * point's closest cluster center.
     * <p>
     * The exact algorithm is as follows:
     * <ol>
     * <li> Choose one center uniformly at random from among the data points.
     * </li>
     * <li> For each data point x, compute D(x), the distance between x and the
     * nearest center that has already been chosen. </li>
     * <li> Choose one new data point at random as a new center, using a
     * weighted probability distribution where a point x is chosen with
     * probability proportional to D<sup>2</sup>(x). </li>
     * <li> Repeat Steps 2 and 3 until k centers have been chosen. </li>
     * <li> Now that the initial centers have been chosen, proceed using
     * standard k-means clustering. </li>
     * </ol>
     * This seeding method gives out considerable improvements in the final
     * error of k-means. Although the initial selection in the algorithm takes
     * extra time, the k-means part itself converges very fast after this
     * seeding and thus the algorithm actually lowers the computation time too.
     *
     * <h2>References</h2>
     * <ol>
     * <li> D. Arthur and S. Vassilvitskii. "K-means++: the advantages of
     * careful seeding". ACM-SIAM symposium on Discrete algorithms, 1027-1035,
     * 2007.</li>
     * <li> Anna D. Peterson, Arka P. Ghosh and Ranjan Maitra. A systematic
     * evaluation of different methods for initializing the K-means clustering
     * algorithm. 2010.</li>
     * </ol>
     *
     * @param <T> the type of input object.
     * @param data data objects array of size n.
     * @param medoids an array of size k to store cluster medoids on output.
     * @param y an array of size n to store cluster labels on output.
     * @param d an array of size n to store the distance of each sample to
     * nearest medoid.
     * @return the initial cluster distortion.
     */
    public static <T> double seed(Distance<T> distance, T[] data, T[] medoids, int[] y, double[] d) {
        int n = data.length;
        int k = medoids.length;
        T medoid = data[randomInt(n)];
        medoids[0] = medoid;

        Arrays.fill(d, Double.MAX_VALUE);

        // pick the next center
        for (int j = 1; j < k; j++) {
            // Loop over the samples and compare them to the most recent center.  Store
            // the distance from each sample to its closest center in scores.
            for (int i = 0; i < n; i++) {
                // compute the distance between this sample and the current center
                double dist = distance.d(data[i], medoid);
                if (dist < d[i]) {
                    d[i] = dist;
                    y[i] = j - 1;
                }
            }

            double cutoff = Math.random() * sum(d);
            double cost = 0.0;
            int index = 0;
            for (; index < n; index++) {
                cost += d[index];
                if (cost >= cutoff) {
                    break;
                }
            }

            medoid = data[index];
            medoids[j] = medoid;
        }

        for (int i = 0; i < n; i++) {
            // compute the distance between this sample and the current center
            double dist = distance.d(data[i], medoid);
            if (dist < d[i]) {
                d[i] = dist;
                y[i] = k - 1;
            }
        }

        double distortion = 0.0;
        for (int i = 0; i < n; ++i) {
            distortion += d[i];
        }

        return distortion;
    }

    /**
     * Returns a random integer in [0, n).
     */
    public static int randomInt(int n) {
        return ((int) Math.random() % n);
    }

    /**
     * Jensen-Shannon divergence JS(P||Q) = (KL(P||M) + KL(Q||M)) / 2, where M =
     * (P+Q)/2. The Jensen-Shannon divergence is a popular method of measuring
     * the similarity between two probability distributions. It is also known as
     * information radius or total divergence to the average. It is based on the
     * Kullback-Leibler divergence, with the difference that it is always a
     * finite value. The square root of the Jensen-Shannon divergence is a
     * metric.
     */
    public static double JensenShannonDivergence(double[] x, double[] y) {
        double[] m = new double[x.length];
        for (int i = 0; i < m.length; i++) {
            m[i] = (x[i] + y[i]) / 2;
        }

        return (KullbackLeiblerDivergence(x, m) + KullbackLeiblerDivergence(y, m)) / 2;
    }

    /**
     * Returns the sum of an array.
     */
    public static int sum(int[] x) {
        double sum = 0.0;

        for (int n : x) {
            sum += n;
        }

        if (sum > Integer.MAX_VALUE || sum < -Integer.MAX_VALUE) {
            throw new ArithmeticException("Sum overflow: " + sum);
        }

        return (int) sum;
    }

    /**
     * Returns the sum of an array.
     */
    public static double sum(float[] x) {
        double sum = 0.0;

        for (float n : x) {
            sum += n;
        }

        return sum;
    }

    /**
     * Returns the sum of an array.
     */
    public static double sum(double[] x) {
        double sum = 0.0;

        for (double n : x) {
            sum += n;
        }

        return sum;
    }

    /**
     * Kullback-Leibler divergence. The Kullback-Leibler divergence (also
     * information divergence, information gain, relative entropy, or KLIC) is a
     * non-symmetric measure of the difference between two probability
     * distributions P and Q. KL measures the expected number of extra bits
     * required to code samples from P when using a code based on Q, rather than
     * using a code based on P. Typically P represents the "true" distribution
     * of data, observations, or a precise calculated theoretical distribution.
     * The measure Q typically represents a theory, model, description, or
     * approximation of P.
     * <p>
     * Although it is often intuited as a distance metric, the KL divergence is
     * not a true metric - for example, the KL from P to Q is not necessarily
     * the same as the KL from Q to P.
     */
    public static double KullbackLeiblerDivergence(double[] x, double[] y) {
        boolean intersection = false;
        double kl = 0.0;

        for (int i = 0; i < x.length; i++) {
            if (x[i] != 0.0 && y[i] != 0.0) {
                intersection = true;
                kl += x[i] * Math.log(x[i] / y[i]);
            }
        }

        if (intersection) {
            return kl;
        } else {
            return Double.POSITIVE_INFINITY;
        }
    }

}
