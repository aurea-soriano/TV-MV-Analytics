/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package normalization;

import java.io.IOException;
import java.util.Arrays;
import matrix.pointsmatrix.AbstractMatrix;
import matrix.pointsmatrix.AbstractVector;
import matrix.pointsmatrix.DenseMatrix;
import matrix.pointsmatrix.DenseVector;
import matrix.pointsmatrix.SparseMatrix;
import matrix.pointsmatrix.SparseVector;
import utils.MatrixOperation;

/**
 * Affine Invariant Norm
 *
 * @author aurea
 */
public class NormalizeColumnsbyAINorm extends Normalization {

    @Override
    public AbstractMatrix execute(AbstractMatrix matrix) throws IOException {
        assert (matrix.getRowCount() > 0) : "More than zero vectors must be used!";

        float[][] points = matrix.toMatrix();

        //calculating the mean
        double[] mean = new double[matrix.getDimensions()];
        Arrays.fill(mean, 0.0);

        for (float[] point : points) {
            //calculating
            for (int j = 0; j < point.length; j++) {
                mean[j] += point[j];

            }
        }

        for (int i = 0; i < mean.length; i++) {
            mean[i] /= points.length;
        }

        double denom = 0.0;
        double denom_part1 = 1.0;
        double denom_part2 = 0.0;
        double[] sumNArray = new double[matrix.getDimensions()];
        Arrays.fill(sumNArray, 0.0);

        for (int i = 0; i < matrix.getRowCount(); i++) {
            double mult = 1.0;
            for (int j = 0; j < matrix.getDimensions(); j++) {

                sumNArray[j] += Math.pow(points[i][j] - mean[j], 2);
                mult *= (points[i][j] - mean[j]);
            }
            denom_part2 += mult;
        }
        for (int j = 0; j < matrix.getDimensions(); j++) {
            sumNArray[j] = sumNArray[j] / matrix.getRowCount();
            denom_part1 = denom_part1 * sumNArray[j];
        }
        denom_part2 = denom_part2 / matrix.getRowCount();
        denom = denom_part1 - Math.pow(denom_part2, 2);
        if (denom == 0.0) {
            denom = 0.001;
        }
        //matrix construction 
        double[][] normMatrix = new double[matrix.getDimensions()][matrix.getDimensions()];
        for (int i = matrix.getDimensions() - 1, row = 0; i >= 0; i--, row++) {
            for (int j = matrix.getDimensions() - 1, col = 0; j >= 0; j--, col++) {
                if (i == j) {
                    normMatrix[row][col] = sumNArray[i] / denom;
                } else {
                    double sum = 0.0;
                    for (int item = 0; item < matrix.getRowCount(); item++) {
                        sum = ((points[item][i] - mean[i]) * (points[item][j] - mean[j]));
                    }
                    sum /= matrix.getRowCount();

                    normMatrix[row][col] = sum * (-1) / denom;
                }
            }
        }

        for (float[] vector : points) {
            //MatrixOperation.getRowFromFloatMatrix(points, i);
            double norm = MatrixOperation.dot(MatrixOperation.multiply(vector, normMatrix), vector);
            if (norm == 0.0) {
                norm = 0.001;
            }
            for (int j = 0; j < vector.length; j++) {
                vector[j] = (float) (vector[j] / norm);
            }
        }

        AbstractMatrix colmatrix = null;

        if (matrix instanceof SparseMatrix) {
            colmatrix = new SparseMatrix();
        } else {
            colmatrix = new DenseMatrix();
        }

        colmatrix.setAttributes(matrix.getAttributes());

        for (int i = 0; i < matrix.getRowCount(); i++) {
            AbstractVector oldv = matrix.getRow(i);
            if (matrix instanceof SparseMatrix) {
                colmatrix.addRow(new SparseVector(points[i], oldv.getId(), oldv.getKlass()));
            } else {
                colmatrix.addRow(new DenseVector(points[i], oldv.getId(), oldv.getKlass()));
            }
        }

        return colmatrix;
    }

}
