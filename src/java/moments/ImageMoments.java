/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package moments;

import utils.points.DoublePoint;

/**
 *
 */
public final class ImageMoments {

    /**
     * Don't let anyone instantiate this class.
     */
    private ImageMoments() {
    }

    /**
     * Compute Raw moment.
     * @param double[][] matrix
     * @param p Order p.
     * @param q Order q.
     * @return Raw moment.
     */
    public static double getRawMoment(double[][] matrix, int p, int q) {
        double m = 0;
        for (int i = 0, k = matrix.length; i < k; i++) {
            for (int j = 0, l = matrix[i].length; j < l; j++) {
                m += Math.pow(i, p) * Math.pow(j, q) * matrix[i][j];
            }
        }
        return m;
    }

    /**
     * Compute central moment.
     * @param double[][] matrix
     * @param p Order p.
     * @param q Order q.
     * @return Central moment.
     */
    public static double getCentralMoment(double[][] matrix, int p, int q) {

        DoublePoint centroid = getCentroid(matrix);

        double mc = 0;
        for (int i = 0, k = matrix.length; i < k; i++) {
            for (int j = 0, l = matrix[i].length; j < l; j++) {
                mc += Math.pow((i - centroid.x), p) * Math.pow((j - centroid.y), q)  * matrix[i][j];
            }
        }
        return mc;
    }

    /**
     * Compute centroid components.
     * @param double[][] matrix
     * @return Centroid.
     */
    public static DoublePoint getCentroid(double[][] matrix) {
        double m00 = ImageMoments.getRawMoment(matrix, 0, 0);
        double m10 = ImageMoments.getRawMoment(matrix, 1, 0);
        double m01 = ImageMoments.getRawMoment(matrix, 0, 1);
        double x0 = m10 / m00;
        double y0 = m01 / m00;
        return new DoublePoint(x0, y0);
    }

    /**
     * Compute Covariance XY.
     *
     * @param double[][] matrix
     * @param p Order p.
     * @param q Order q.
     * @return Covariance.
     */
    public static double getCovarianceXY(double[][] matrix, int p, int q) {
        double mc00 = ImageMoments.getCentralMoment(matrix, 0, 0);
        double mc11 = ImageMoments.getCentralMoment(matrix, 1, 1);
        return mc11 / mc00;
    }

    /**
     * Compute variance X.
     * @param double[][] matrix
     * @param p Order p.
     * @param q Order q.
     * @return Variance X.
     */
    public static double getVarianceX(double[][] matrix, int p, int q) {
        double mc00 = ImageMoments.getCentralMoment(matrix, 0, 0);
        double mc20 = ImageMoments.getCentralMoment(matrix, 2, 0);
        return mc20 / mc00;
    }

    /**
     * Compute variance Y.
     * @param double[][] matrix
     * @param p Order p.
     * @param q Order q.
     * @return Variace Y.
     */
    public static double getVarianceY(double[][] matrix, int p, int q) {
        double mc00 = ImageMoments.getCentralMoment(matrix, 0, 0);
        double mc02 = ImageMoments.getCentralMoment(matrix, 0, 2);
        return mc02 / mc00;
    }

    /**
     * Compute orientation in radians.
     *
     * @param double[][] matrix
     * @return Orientation from the image.
     */
    public static double getOrientation(double[][] matrix) {
        double cm11 = ImageMoments.getCentralMoment(matrix, 1, 1);
        double cm20 = ImageMoments.getCentralMoment(matrix, 2, 0);
        double cm02 = ImageMoments.getCentralMoment(matrix, 0, 2);

        return 0.5 * Math.atan((2 * cm11) / (cm20 - cm02));
    }

    /**
     * Compute projection skewness.
     *
     * @param double[][] matrix
     * @return Projection skewness.
     */
    public static DoublePoint getProjectionSkewness(double[][] matrix) {
        double u30 = ImageMoments.getCentralMoment(matrix, 3, 0);
        double u03 = ImageMoments.getCentralMoment(matrix, 0, 3);
        double u20 = ImageMoments.getCentralMoment(matrix, 2, 0);
        double u02 = ImageMoments.getCentralMoment(matrix, 0, 2);

        double skx = u30 / Math.pow(u20, 1.5);
        double sky = u03 / Math.pow(u02, 1.5);

        return new DoublePoint(skx, sky);
    }

    /**
     * Compute projection kurtosis.
     *
     * @param double[][] matrix
     * @return Projection kurtorsis.
     */
    public static DoublePoint getProjectionKurtosis(double[][] matrix) {
        double u40 = ImageMoments.getCentralMoment(matrix, 4, 0);
        double u20 = ImageMoments.getCentralMoment(matrix, 2, 0);
        double u04 = ImageMoments.getCentralMoment(matrix, 0, 4);
        double u02 = ImageMoments.getCentralMoment(matrix, 0, 2);

        double skx = (u40 / Math.pow(u20, 2)) - 3;
        double sky = (u04 / Math.pow(u02, 2)) - 3;

        return new DoublePoint(skx, sky);
    }

    /**
     * Normalized Central Moment.
     *
     * @param double[][] matrix
     * @param p Order p.
     * @param q Order q.
     * @return Normalized central moment.
     */
    public static double getNormalizedCentralMoment(double[][] matrix, int p, int q) {
        double gama = ((p + q) / 2) + 1;
        double mpq = ImageMoments.getCentralMoment(matrix, p, q);
        double m00gama = Math.pow(mpq, gama);
        return mpq / m00gama;
    }

    /**
     * Abo-Zaid Normalized Central Moment.
     * @param double[][] matrix
     * @param p Order p.
     * @param q Order q.
     * @return Abo-Zaid normalized central moment.
     */
    public static double getZaidNormalizedCentralMoment(double[][] matrix, int p, int q) {

        double mpq = ImageMoments.getCentralMoment(matrix, p, q);
        double m00 = ImageMoments.getCentralMoment(matrix, 0, 0);
        double m20 = ImageMoments.getCentralMoment(matrix, 2, 0);
        double m02 = ImageMoments.getCentralMoment(matrix, 0, 2);

        return mpq * (1 / m00)
                * Math.pow(m00 / (m20 + m02), (p + q) / 2);

    }
}
