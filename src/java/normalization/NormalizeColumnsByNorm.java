/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package normalization;

import java.io.IOException;
import matrix.pointsmatrix.AbstractMatrix;
import matrix.pointsmatrix.AbstractVector;
import matrix.pointsmatrix.DenseMatrix;
import matrix.pointsmatrix.DenseVector;
import matrix.pointsmatrix.SparseMatrix;
import matrix.pointsmatrix.SparseVector;

/**
 *
 * @author aurea
 */
public class NormalizeColumnsByNorm extends Normalization {

    @Override
    public AbstractMatrix execute(AbstractMatrix matrix) throws IOException {
        assert (matrix.getRowCount() > 0) : "More than zero vectors must be used!";

        float[][] points = matrix.toMatrix();

        for (int j = 0; j < matrix.getDimensions(); j++) {
            double norm = 0.0;

            for (int i = 0; i < matrix.getRowCount(); i++) {
                norm += Math.pow(points[i][j], 2);
            }
            norm= Math.sqrt(norm);
            norm = norm * 10000;
            norm = Math.round(norm);
            norm = norm / 10000;
            if(norm==0)
            {
                norm=0.001;
            }

            for (int i = 0; i < matrix.getRowCount(); i++) {
                double point = points[i][j] / norm;

                points[i][j] = (float) point;
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
