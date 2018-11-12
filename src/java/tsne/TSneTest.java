/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tsne;

import java.io.File;

/**
 *
 * @author aurea
 */
public class TSneTest {

    // sample client for testing
    public static void main(String[] args) {

        int initial_dims = 4;
        double perplexity = 20.0;
        double[][] X = MatrixUtils.simpleRead2DMatrix(new File("src/java/tsne/data/iris_X.txt"), ",");
        //System.out.println(MatrixOps.doubleArrayToPrintString(X, ", ", 50, 10));
        TSne tsne = new MemOptimizedTSne();
        
        double[][] Y = tsne.tsne(X, 2, initial_dims, perplexity);
        System.out.println(MatrixOps.doubleArrayToPrintString(Y, ", ", 151, 10));

    // Plot Y or save Y to file and plot with some other tool such as for instance R
    }
}
