/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package moments;

import dataMaker.Matrix;
import java.util.ArrayList;
import matrix.pointsmatrix.AbstractVector;
import matrix.pointsmatrix.DenseVector;
import utils.Operations;
import utils.Util;
import utils.points.Complex2;

/**
 *
 * @author aurea
 */
public class MomentMaker {

    /* n = order, m= repetition, just for vector
     */
    public static Complex2 zernikeMomentGeneral(int n, int m, Matrix matrix) {
        double zr = 0;
        double zi = 0;
        double cnt = 0;
        int N1 = matrix.getRows();
        int N2 = matrix.getCols();
        for (int y = 0; y < N1; y++) {
            for (int x = 0; x < N2; x++) {
                double rho = Math.sqrt((Math.pow((2 * x) - N2 + 1, 2) / N2)
                        + (Math.pow(N1 - 1 - (2 * y), 2) / N1));
                if (rho <= 2.f) {
                    double radial = Operations.radialPolynomial(rho, n, m);
                    double theta = Math.atan2((N1 - 1 - (2 * y)), ((2 * x) - N2 + 1));
                    zr = (zr + matrix.getValue(y, x) * radial * Math.cos(m * theta));
                    zi = (zi + matrix.getValue(y, x) * radial * Math.sin(m * theta));
                    cnt = cnt + 1;
                }
            }
        }
        Complex2 result = new Complex2((((zr * n) + zr) / cnt), (((zi * n) + zi) / cnt));
        return result;
    }

    /*    
     */
    public static ArrayList<Double> zernikeMomentsArray(Matrix matrixValues) {
        
        ArrayList<Double> zernikeMoments = new ArrayList<>();
        for (int n = 0; n <= 7; n++) {
            for (int m = 0; m <= 7; m++) {
                if (m <= n && ((n - m) % 2) == 0) {
                    zernikeMoments.add(zernikeMomentGeneral(n, m, matrixValues).re());
                    //System.out.println(zernikeMoments.get(zernikeMoments.size()-1));
                }
            }
        }
        return zernikeMoments;
    }

    public static AbstractVector zernikeMomentsAbstractVector2(Matrix matrixValues) {

        ArrayList<Double> vectorList = new ArrayList<>();
        for (int n = 0; n <= 7; n++) {
            for (int m = 0; m <= 7; m++) {
                if (m <= n && ((n - m) % 2) == 0) {
                    vectorList.add(zernikeMomentGeneral(n, m, matrixValues).re());
                }
            }
        }

        float[] values = new float[vectorList.size()];
        for (int j = 0; j < vectorList.size(); j++) {
            Double value = vectorList.get(j);
            System.out.print(value + ", ");
            values[j] = Float.valueOf(value.toString());
        }
        System.out.println();
        AbstractVector zernikeMoments = new DenseVector(values);
        return zernikeMoments;
    }

    /**
     * Jose Antonio Martin H., Matilde Santos & Javier de Lope (2010),
     * Orthogonal Variant Moments Features in Image Analysis , Information
     * Sciences, March, 2010. Vol. 180(6), pp. 846 - 860. [DOI] [URL]
     *
     * @param matrixValues
     * @return
     */
    public static AbstractVector orthogonalVariantAndStatisticalMoments(Matrix matrix) {

        double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        matrixValues = Operations.sumScalarPlusValueMatrix(matrixValues, 1);

        int tamX = matrix.getCols();
        int tamY = matrix.getRows();

        float box = tamX * tamY;

        double area = Operations.sumValuesMatrix(matrixValues);

        double[][] dY = Operations.diffY(matrixValues);
        double[][] dX = Operations.diffX(matrixValues);

        double mDy = Operations.sumValuesMatrix(Operations.abs(dY));
        double mDx = Operations.sumValuesMatrix(Operations.abs(dX));

        double[] ly = Operations.fillVectorValuesOrdered(tamY - 1);
        double[] lx = Operations.fillVectorValuesOrdered(tamX - 1);

        // steps for Surface Length
        //dX.^2.0
        double[][] dX_2 = Operations.pow(dX, 2);
        double[][] dY_2 = Operations.pow(dY, 2);

        //1.0+(dX.^2.0)
        double[][] sdX_2 = Operations.sumScalarPlusValueMatrix(dX_2, 1.0);
        double[][] sdY_2 = Operations.sumScalarPlusValueMatrix(dY_2, 1.0);

        //sqrt(1.0 +(dX.^2.0))
        double[][] sqdX_2 = Operations.sqrt(sdX_2);
        double[][] sqdY_2 = Operations.sqrt(sdY_2);

        //sum(sqrt(1.0 +(dX.^2.0)),2)
        double[] rowSumX_2 = Operations.sumInY(sqdX_2);
        double[] rowSumY_2 = Operations.sumInY(sqdY_2);

        //(1.0+sum(sqrt(1.0 +(dX.^2.0)),2))
        double[] rowSum1X_2 = Operations.sumScalarPlusValueVector(rowSumX_2, 1.0);
        double[] rowSum1Y_2 = Operations.sumScalarPlusValueVector(rowSumY_2, 1.0);

        //sum(1.0+sum(sqrt(1.0 +(dX.^2.0)),2))
        double sumDX_2 = Operations.sumValuesVector(rowSum1X_2);
        double sumDY_2 = Operations.sumValuesVector(rowSum1Y_2);

        // Surface length
        //Lx=(1.0+sum(1.0+sum(sqrt(1.0+(dX.^2.0)),2))) / BOX ;
        //Ly=(1.0+sum(1.0+sum(sqrt(1.0+(dY.^2.0)),2))) / BOX ;
        if (box == 0.f) {
            box = 0.1f;
        }
        double Lx = (1.0 + sumDX_2) / box;
        double Ly = (1.0 + sumDY_2) / box;

        // Position components
        //(0.1+(mDx/(4.5)))
        //(0.1+(mDy/(8.0)))
        double denominatorPx = 0.1 + (mDx / (4.5));
        double denominatorPy = 0.1 + (mDy / (8.0));

        //abs(dX)
        //abs(dY)
        double[][] absDX = Operations.abs(dX);
        double[][] absDY = Operations.abs(dY);

        double numeratorPx = 1 + Operations.sumValuesVector(Operations.multiplyVectorAndMatrix(absDX, lx));
        double numeratorPy = 1 + Operations.sumValuesVector(Operations.multiplyVectorAndMatrix(ly, absDY));

        //Px=( 1+sum(abs(dX)*lx') ) ./ (0.1+(mDx/(4.5)));
        //Py=( 1+sum(ly*abs(dY) ) ) ./ (0.1+(mDy/(8.0)));
        double Px = numeratorPx / denominatorPx;
        double Py = numeratorPy / denominatorPy;

        float[] values = new float[10];

        int count = 0;
        float mean, std;
        values[count] = (float) area / 255.f;
        count++;
        values[count] = (float) Lx;
        count++;
        values[count] = (float) Ly;
        count++;
        values[count] = (float) Px;
        count++;
        values[count] = (float) Py;
        count++;
        values[count] = mean = (float) Operations.meanMoment(matrixValues);
        count++;
        values[count] = std = (float) Operations.standarddeviationMoment(matrixValues);
        count++;
        values[count] = (float) Operations.skewnessMoment(matrixValues, std);
        count++;
        values[count] = (float) Operations.kurtosisMoment(matrixValues, std);
        count++;
        values[count] = (float) Operations.uniformity(std, mean);
        AbstractVector orthogonalVariantMoments = new DenseVector(values);
        return orthogonalVariantMoments;
    }

    /**
     * Jose Antonio Martin H., Matilde Santos & Javier de Lope (2010),
     * Orthogonal Variant Moments Features in Image Analysis , Information
     * Sciences, March, 2010. Vol. 180(6), pp. 846 - 860. [DOI] [URL]
     *
     * @param matrix
     * @return
     */
    public static AbstractVector orthogonalVariantMoments(Matrix matrix) {

        double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        matrixValues = Operations.sumScalarPlusValueMatrix(matrixValues, 1);

        int tamX = matrix.getCols();
        int tamY = matrix.getRows();

        float box = tamX * tamY;

        double area = Operations.sumValuesMatrix(matrixValues);

        double[][] dY = Operations.diffY(matrixValues);
        double[][] dX = Operations.diffX(matrixValues);

        double mDy = Operations.sumValuesMatrix(Operations.abs(dY));
        double mDx = Operations.sumValuesMatrix(Operations.abs(dX));

        double[] ly = Operations.fillVectorValuesOrdered(tamY - 1);
        double[] lx = Operations.fillVectorValuesOrdered(tamX - 1);

        // steps for Surface Length
        //dX.^2.0
        double[][] dX_2 = Operations.pow(dX, 2);
        double[][] dY_2 = Operations.pow(dY, 2);

        //1.0+(dX.^2.0)
        double[][] sdX_2 = Operations.sumScalarPlusValueMatrix(dX_2, 1.0);
        double[][] sdY_2 = Operations.sumScalarPlusValueMatrix(dY_2, 1.0);

        //sqrt(1.0 +(dX.^2.0))
        double[][] sqdX_2 = Operations.sqrt(sdX_2);
        double[][] sqdY_2 = Operations.sqrt(sdY_2);

        //sum(sqrt(1.0 +(dX.^2.0)),2)
        double[] rowSumX_2 = Operations.sumInY(sqdX_2);
        double[] rowSumY_2 = Operations.sumInY(sqdY_2);

        //(1.0+sum(sqrt(1.0 +(dX.^2.0)),2))
        double[] rowSum1X_2 = Operations.sumScalarPlusValueVector(rowSumX_2, 1.0);
        double[] rowSum1Y_2 = Operations.sumScalarPlusValueVector(rowSumY_2, 1.0);

        //sum(1.0+sum(sqrt(1.0 +(dX.^2.0)),2))
        double sumDX_2 = Operations.sumValuesVector(rowSum1X_2);
        double sumDY_2 = Operations.sumValuesVector(rowSum1Y_2);

        // Surface length
        //Lx=(1.0+sum(1.0+sum(sqrt(1.0+(dX.^2.0)),2))) / BOX ;
        //Ly=(1.0+sum(1.0+sum(sqrt(1.0+(dY.^2.0)),2))) / BOX ;
        if (box == 0.f) {
            box = 0.1f;
        }
        double Lx = (1.0 + sumDX_2) / box;
        double Ly = (1.0 + sumDY_2) / box;

        // Position components
        //(0.1+(mDx/(4.5)))
        //(0.1+(mDy/(8.0)))
        double denominatorPx = 0.1 + (mDx / (4.5));
        double denominatorPy = 0.1 + (mDy / (8.0));

        //abs(dX)
        //abs(dY)
        double[][] absDX = Operations.abs(dX);
        double[][] absDY = Operations.abs(dY);

        double numeratorPx = 1 + Operations.sumValuesVector(Operations.multiplyVectorAndMatrix(absDX, lx));
        double numeratorPy = 1 + Operations.sumValuesVector(Operations.multiplyVectorAndMatrix(ly, absDY));

        //Px=( 1+sum(abs(dX)*lx') ) ./ (0.1+(mDx/(4.5)));
        //Py=( 1+sum(ly*abs(dY) ) ) ./ (0.1+(mDy/(8.0)));
        double Px = numeratorPx / denominatorPx;
        double Py = numeratorPy / denominatorPy;

        float[] values = new float[5];

        int count = 0;
        float mean, std;
        values[count] = (float) area / 255.f;
        count++;
        values[count] = (float) Lx;
        count++;
        values[count] = (float) Ly;
        count++;
        values[count] = (float) Px;
        count++;
        values[count] = (float) Py;
        AbstractVector orthogonalVariantMoments = new DenseVector(values);
        return orthogonalVariantMoments;
    }

    public static AbstractVector statisticalMomentsVector(Matrix matrix, float missingData) {

        float std, mean;
        double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        float[] values = new float[6];
        int count = 0;
        values[count] = mean = (float) Operations.meanMoment(matrixValues);
        count++;
        values[count] = std = (float) Operations.standarddeviationMoment(matrixValues);
        count++;
        values[count] = (float) Operations.skewnessMoment(matrixValues, std);
        count++;
        values[count] = (float) Operations.kurtosisMoment(matrixValues, std);
        count++;
        values[count] = (float) Operations.uniformity(std, mean);
        count++;
        values[count] = (float) missingData;
        AbstractVector colorMoments = new DenseVector(values);
        return colorMoments;
    }

    public static AbstractVector normalizedcentralMomentsVector(Matrix matrix) {

        ArrayList<Double> normalizedcentralMomentsVector = new ArrayList<>();
        double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        for (int n = 0; n <= 3; n++) {
            for (int m = 0; m <= 3; m++) {
                normalizedcentralMomentsVector.add(Moments.getNormalizedCentralMoment(n, m, matrixValues));
            }

        }

        int sizeTotalVector = normalizedcentralMomentsVector.size();
        float[] values = new float[sizeTotalVector];

        int count = 0;

        for (Double value : normalizedcentralMomentsVector) {
            values[count] = Float.valueOf(value.toString());
            count++;
        }

        AbstractVector moments = new DenseVector(values);
        return moments;

    }


    /* public static AbstractVector orthogonalVariantMomentsVector(Matrix matrixValues) {
        double[] momentsArray = null;
        OrthogonalVariantMoments ovm = new OrthogonalVariantMoments();
        momentsArray = ovm.Compute(matrixValues.getV());
        float[] values = new float[5];
        for (int i = 0; i < momentsArray.length; i++) {
            values[i] = (float) momentsArray[i];
        }
        AbstractVector moments = new DenseVector(values);
        return moments;
    }*/
    public static AbstractVector zaidNormalizedcentralMomentsVector(Matrix matrix) {

        ArrayList<Double> zaidNormalizedcentralMomentsVector = new ArrayList<>();
        double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        for (int n = 0; n <= 3; n++) {
            for (int m = 0; m <= 3; m++) {
                zaidNormalizedcentralMomentsVector.add(ImageMoments.getZaidNormalizedCentralMoment(matrixValues, n, m));
            }

        }

        int sizeTotalVector = zaidNormalizedcentralMomentsVector.size();
        float[] values = new float[sizeTotalVector];

        int count = 0;

        for (Double value : zaidNormalizedcentralMomentsVector) {
            values[count] = Float.valueOf(value.toString());
            count++;
        }

        AbstractVector moments = new DenseVector(values);
        return moments;

    }

    public static AbstractVector huMomentsVector(Matrix matrix) {
        /**
         * Hu described M1 to M6 as absolute orthogonal invariants (independent
         * of position, size, and orientation) and M7 as a skew orthogonal
         * invariant (useful in distinguishing mirror images). These features
         * are capable of recognizing simple objects, such as a character in
         * Hu's experiment. M7 is different because it is a feature of a skew
         * invariant, whereas the rest are used for position, size and rotation
         * invariants
         */
 double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        int numberMoments = 7;
        float[] values = new float[numberMoments];
        int count = 0;

        for (int n = 1; n <= numberMoments; n++) {//7
            Double value = Moments.getHuMoment(matrixValues, n);
            values[count] = Float.valueOf(value.toString());
            count++;
        }
        AbstractVector moments = new DenseVector(values);
        return moments;

    }

    public static AbstractVector emptyMomentVector(int spacesNumber) {

        float[] values = new float[spacesNumber];

        for (int n = 0; n < spacesNumber; n++) {//7

            values[n] = -1;
        }
        AbstractVector moments = new DenseVector(values);
        return moments;

    }

    public static AbstractVector huStatisticalMomentsVector(Matrix matrix, float missingData) {

        ArrayList<Double> huMomentsVector = new ArrayList<>();
 double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        for (int n = 1; n <= 7; n++) {//7 
            huMomentsVector.add(Moments.getHuMoment(matrixValues, n));
        }

        int sizeTotalVector = huMomentsVector.size();
        float[] values = new float[sizeTotalVector + 6];

        float std, mean;
        int count = 0;

        for (Double value : huMomentsVector) {
            values[count] = Float.valueOf(value.toString());
            count++;
        }

        values[count] = mean = (float) Operations.meanMoment(matrixValues);
        count++;
        values[count] = std = (float) Operations.standarddeviationMoment(matrixValues);
        count++;
        values[count] = (float) Operations.skewnessMoment(matrixValues, std);
        count++;
        values[count] = (float) Operations.kurtosisMoment(matrixValues, std);
        count++;
        values[count] = (float) Operations.uniformity(std, mean);
        count++;
        values[count] = missingData;

        AbstractVector moments = new DenseVector(values);
        return moments;

    }

    public static AbstractVector correlationMoments(Matrix matrix, float missingData) {

         double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        double[][] correlationMatrix = Operations.calculateCorrelationMatrix(matrixValues);

        ArrayList<Double> huMomentsVector = new ArrayList<>();

        for (int n = 1; n <= 7; n++) {//7
            huMomentsVector.add(Moments.getHuMoment(correlationMatrix, n));
        }

        int sizeTotalVector = huMomentsVector.size();
        float[] values = new float[sizeTotalVector + 6];

        int count = 0;

        for (Double value : huMomentsVector) {
            values[count] = Float.valueOf(value.toString());
            count++;
        }

        float std, mean;

        values[count] = mean = (float) Operations.meanMoment(correlationMatrix);
        count++;
        values[count] = std = (float) Operations.standarddeviationMoment(correlationMatrix);
        count++;
        values[count] = (float) Operations.skewnessMoment(correlationMatrix, std);
        count++;
        values[count] = (float) Operations.kurtosisMoment(correlationMatrix, std);
        count++;
        values[count] = (float) Operations.uniformity(std, mean);
        count++;
        values[count] = missingData;

        AbstractVector moments = new DenseVector(values);
        return moments;

    }

    public static AbstractVector flusserSukMomentsVector(Matrix matrix) {
         double[][] matrixValues = matrix.getMatrix().clone();
        matrixValues = Operations.cleanNaN(matrixValues);
        FlusserSukMoments fskMoments = new FlusserSukMoments();
        double[] fskMomentsVector = fskMoments.Compute(matrixValues);

        float[] values = new float[fskMomentsVector.length];

        int count = 0;
        for (Double value : fskMomentsVector) {
            values[count] = Float.valueOf(value.toString());
            count++;
        }

        AbstractVector moments = new DenseVector(values);
        return moments;

    }

}
