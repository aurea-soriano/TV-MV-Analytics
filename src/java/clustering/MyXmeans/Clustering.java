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
/**
 * Clustering interface.
 * 
 * @param <T> the type of input object.
 * 
 * @author Haifeng Li
 */
public interface Clustering <T> {
    /**
     * Cluster label for outliers or noises.
     */
    public static final int OUTLIER = Integer.MAX_VALUE;
    
    /**
     * Cluster a new instance.
     * @param x a new instance.
     * @return the cluster label.
     */
    public int predict(T x);
}