/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tsne;

import java.io.IOException;
import java.util.ArrayList;
import matrix.distancematrix.DistanceMatrix;
import distance.AbstractDissimilarity;
import matrix.pointsmatrix.AbstractMatrix;
import matrix.pointsmatrix.AbstractVector;
import matrix.pointsmatrix.DenseMatrix;
import matrix.pointsmatrix.DenseVector;
import projection.Projection;

/**
 *
 * @author aurea
 */
public class TSneProjection implements Projection {

    public TSneProjection() {
        this.typeTSne = "SimpleTSne";
        this.projDimen = 2;
        this.perplexity = 50.0;

    }

    public double getPerplexity() {
        return perplexity;
    }

    public void setPerplexity(double perplexity) {
        this.perplexity = perplexity;
    }

    public String getTypeTSne() {
        return typeTSne;
    }

    public void setTypeTSne(String typeTSne) {
        this.typeTSne = typeTSne;
    }
    TSne tsne = new MemOptimizedTSne();

    @Override
    public AbstractMatrix project(AbstractMatrix matrix, AbstractDissimilarity diss) throws IOException {
        this.initialDims = matrix.getDimensions();
        double[][] X = utils.Util.convertFloatMatrixToDoubleMatrix(matrix.toMatrix());
        TSne tsneTechnique = null;
        switch (typeTSne) {
            case "FastTSne":
                tsneTechnique = new FastTSne();
                break;
            case "MemOptimizedTSne":
                tsneTechnique = new MemOptimizedTSne();
                break;
            case "SimpleTSne":
                tsneTechnique = new SimpleTSne();
                break;
            default:
                tsneTechnique = null;
                break;
        }
     
        if (tsneTechnique != null) {
            double[][] Y = tsneTechnique.tsne(X, this.projDimen, this.initialDims, this.perplexity);

            AbstractMatrix projection = new DenseMatrix();

            ArrayList<Integer> ids = matrix.getIds();
            float[] cdata = matrix.getClassData();
            ArrayList<String> labels = matrix.getLabels();

            for (int i = 0; i < matrix.getRowCount(); i++) {
                float[] unitProjection = new float[2];
                unitProjection[0] = (float) Y[i][0];
                unitProjection[1] = (float) Y[i][1];
                AbstractVector vector = new DenseVector(unitProjection, ids.get(i), cdata[i]);

                if (labels.isEmpty()) {
                    projection.addRow(vector);
                } else {
                    projection.addRow(vector, labels.get(i));
                }
            }
            return projection;
        }
        return null;

    }

    @Override
    public AbstractMatrix project(DistanceMatrix dmat) throws IOException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    private String typeTSne;
    private int projDimen;
    private int initialDims;
    private double perplexity;

}
