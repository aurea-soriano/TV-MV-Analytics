/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package moments;

/**
 *
 * @author aurea
 */
public class OrthogonalVariantMoments {
        /**
     * Initialize a new instance of the OrthogonalVariantMoments class.
     */
    public OrthogonalVariantMoments() {}
       /**
     * Sum absolute of all the elements in the matrix.
     * @param A Matrix.
     * @return Sum of the Matrix.
     */
      public  double SumAbs(double[][] A){
        double sum = 0;
        for (double[] A1 : A) {
            for (int j = 0; j < A[0].length; j++) {
                sum += Math.abs(A1[j]);
            }
        }
        
        return sum;
    }
    
      
      
    /**
     * Compute OVM.
     * @param fastBitmap Image to be processed.
     * @return 5 OV moments.
     */
    public double[] Compute(double[][] matrix){
        
      
        
        // 5 moments: A, Lx, Ly, Px, Py
        double[] moments = new double[5];
        
        // Moment: Area
        moments[0] = ImageMoments.getRawMoment(matrix, 0, 0);
        
    
        double box = matrix.length * matrix[0].length;
        
        // Moment: Ly
        double[][] diff = new double[matrix.length - 1][matrix[0].length];
        for (int i = 0; i < matrix.length - 1; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                diff[i][j] =  matrix[i+1][j] - matrix[i][j];
            }
        }
        
        double m = SumAbs(diff);
        
        double ly = 0;
        for (double[] diff1 : diff) {
            for (int j = 0; j < diff[0].length; j++) {
                ly += Math.sqrt((diff1[j] * diff1[j]) + 1);
            }
        }
        
        moments[2] = (ly + 3) / box;
        
        // Moment: Py
        double den = (m / 8.0) + 0.1;
        double dsum = 1;
        for (int i = 0; i < diff.length; i++) {
            for (int j = 0; j < diff[0].length; j++) {
                dsum += Math.abs(diff[i][j]) * (i+1);
            }
        }
        
        moments[4] = (dsum + 1) / den;
       
        // Moment: Lx
        diff =  new double[matrix.length - 1][matrix[0].length];
         for (int i = 0; i < diff.length; i++) {
             for (int j = 0; j < diff[0].length; j++) {
                 diff[i][j] = matrix[i][j+1] +matrix[i][j];
             }
         }
       
         m = SumAbs(diff);
        
        double lx = 0;
        for (double[] diff1 : diff) {
            for (int j = 0; j < diff[0].length; j++) {
                lx += Math.sqrt((diff1[j] * diff1[j]) + 1);
            }
        }
        
        moments[1] = (lx + 3) / box;
        
        // Moment: Px
        den = (m / 4.5) + 0.1;
        dsum = 1;
        for (double[] diff1 : diff) {
            for (int j = 0; j < diff[0].length; j++) {
                dsum += Math.abs(diff1[j]) * (j+1);
            }
        }
        
       moments[3] = (dsum + 1) / den;
        
       return moments;
        
    }
    
}
