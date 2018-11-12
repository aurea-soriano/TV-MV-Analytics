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
public enum ClusteringDistance {
    /**
     * Squared Euclidean distance for K-Means.
     */
    EUCLIDEAN,
    /**
     * Squared Euclidean distance with missing value handling for K-Means.
     */
    EUCLIDEAN_MISSING_VALUES,
    /**
     * Jensen-Shannon divergence for SIB.
     */
    JENSEN_SHANNON_DIVERGENCE
}