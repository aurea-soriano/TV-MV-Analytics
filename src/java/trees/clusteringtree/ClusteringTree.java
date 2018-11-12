/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trees.clusteringtree;

import clustering.BKmeans;
import clustering.BKmedoids;
import clustering.Clustering;
import clustering.Kmeans;
import clustering.Kmedoids;
import clustering.Xmeans;
import java.io.IOException;
import java.util.ArrayList;
import matrix.pointsmatrix.AbstractMatrix;
import matrix.pointsmatrix.DenseMatrix;
import distance.EuclideanSimilarity;

/**
 *
 * @author aurea
 */
public class ClusteringTree {

    private ClusteringNode root;
    private Integer totalLevels = 0;

    /*
     * construct an empty set of points
     */
    public ClusteringTree() {

    }

    public Integer getDepth() {
        return totalLevels;
    }

    public ClusteringNode getRoot() {
        return root;
    }

    public void buildInitialClusteringTree(int depth, AbstractMatrix abstractMatrix, String clusteringMethodStr, int numberClusters) throws IOException {

        if (abstractMatrix == null || abstractMatrix.getRowCount() == 0) {
            return;
        }

        Clustering clusteringMethod = null;
        if (clusteringMethodStr.equals("Xmeans")) {
            clusteringMethod = new Xmeans(abstractMatrix.getRowCount());
        } else {
            if (clusteringMethodStr.equals("Kmeans")) {
                clusteringMethod = new Kmeans(numberClusters);
            } else {
                if (clusteringMethodStr.equals("Kmedoids")) {
                    clusteringMethod = new Kmedoids(numberClusters);
                } else {

                    if (clusteringMethodStr.equals("BKmeans")) {
                        clusteringMethod = new BKmeans(numberClusters);
                    } else {

                        if (clusteringMethodStr.equals("BKmedoids")) {
                            clusteringMethod = new BKmedoids(numberClusters);
                        }
                    }
                }
            }
        }

        //new Xmeans(abstractMatrix.getRowCount());
        ArrayList<ArrayList<Integer>> resultClustering = clusteringMethod.execute(new EuclideanSimilarity(), abstractMatrix);
        int[] listMedoidsCluster = clusteringMethod.getMedoids(abstractMatrix);

        ArrayList<Integer> listMembers = new ArrayList<Integer>();
        ArrayList<Integer> listMedoids = new ArrayList<Integer>();

        for (int i = 0; i < abstractMatrix.getRowCount(); i++) {
            listMembers.add(i);
        }

        for (int i = 0; i < listMedoidsCluster.length; i++) {
            listMedoids.add(listMedoidsCluster[i]);
        }

        this.root = new ClusteringNode(abstractMatrix, listMedoids, depth, listMembers, null);

        if (resultClustering.size() > 1) {

            for (int i = 0; i < resultClustering.size(); i++) {
                AbstractMatrix childAbstractMatrix = new DenseMatrix();

                ArrayList<Integer> childListMembers = new ArrayList<Integer>();
                ArrayList<Integer> childListMedoids = new ArrayList<Integer>();

                for (int j = 0; j < resultClustering.get(i).size(); j++) {
                    childAbstractMatrix.addRow(abstractMatrix.getRow(resultClustering.get(i).get(j)), abstractMatrix.getLabel(resultClustering.get(i).get(j)));
                    childListMembers.add(listMembers.get(resultClustering.get(i).get(j)));

                }
                Clustering childClusteringMethod = new Xmeans(childAbstractMatrix.getRowCount());
                ArrayList<ArrayList<Integer>> childResultClustering = childClusteringMethod.execute(new EuclideanSimilarity(), childAbstractMatrix);

                int[] childListMedoidsCluster = childClusteringMethod.getMedoids(childAbstractMatrix);

                for (int k = 0; k < childListMedoidsCluster.length; k++) {
                    childListMedoids.add(childListMembers.get(childListMedoidsCluster[k]));
                }

                ClusteringNode clusteringNode = new ClusteringNode(childAbstractMatrix, childListMedoids, depth + 1, childListMembers, this.root);

                this.root.addChildNode(clusteringNode);

                if (childResultClustering.size() > 1) {
                    buildTimeIntervalTree(this.root.getListChildNodes().get(i), depth + 1, childClusteringMethod, childResultClustering, clusteringMethodStr, numberClusters);
                } else {
                    if (childResultClustering.size() == 1) {
                        ClusteringNode uniqueClusteringNode = new ClusteringNode(childAbstractMatrix, childListMembers, depth + 2, childListMembers, this.root.getListChildNodes().get(i));
                        this.root.getListChildNodes().get(i).addChildNode(uniqueClusteringNode);
                        if (totalLevels < depth + 2);
                        {
                            totalLevels = depth + 2;
                        }
                    }
                }
            }
        }

    }
    
    public void buildClusteringTree(int depth, AbstractMatrix abstractMatrix, String clusteringMethodStr, int numberClusters,    Clustering clusteringMethod, ArrayList<ArrayList<Integer>> resultClustering) throws IOException {

        if (abstractMatrix == null || abstractMatrix.getRowCount() == 0) {
            return;
        }
        int[] listMedoidsCluster = clusteringMethod.getMedoids(abstractMatrix);

        ArrayList<Integer> listMembers = new ArrayList<Integer>();
        ArrayList<Integer> listMedoids = new ArrayList<Integer>();

        for (int i = 0; i < abstractMatrix.getRowCount(); i++) {
            listMembers.add(i);
        }

        for (int i = 0; i < listMedoidsCluster.length; i++) {
            listMedoids.add(listMedoidsCluster[i]);
        }

        this.root = new ClusteringNode(abstractMatrix, listMedoids, depth, listMembers, null);

        if (resultClustering.size() > 1) {

            for (int i = 0; i < resultClustering.size(); i++) {
                AbstractMatrix childAbstractMatrix = new DenseMatrix();

                ArrayList<Integer> childListMembers = new ArrayList<Integer>();
                ArrayList<Integer> childListMedoids = new ArrayList<Integer>();

                for (int j = 0; j < resultClustering.get(i).size(); j++) {
                    childAbstractMatrix.addRow(abstractMatrix.getRow(resultClustering.get(i).get(j)), abstractMatrix.getLabel(resultClustering.get(i).get(j)));
                    childListMembers.add(listMembers.get(resultClustering.get(i).get(j)));

                }
                Clustering childClusteringMethod = new Xmeans(childAbstractMatrix.getRowCount());
                ArrayList<ArrayList<Integer>> childResultClustering = childClusteringMethod.execute(new EuclideanSimilarity(), childAbstractMatrix);

                int[] childListMedoidsCluster = childClusteringMethod.getMedoids(childAbstractMatrix);

                for (int k = 0; k < childListMedoidsCluster.length; k++) {
                    childListMedoids.add(childListMembers.get(childListMedoidsCluster[k]));
                }

                ClusteringNode clusteringNode = new ClusteringNode(childAbstractMatrix, childListMedoids, depth + 1, childListMembers, this.root);

                this.root.addChildNode(clusteringNode);

                if (childResultClustering.size() > 1) {
                    buildTimeIntervalTree(this.root.getListChildNodes().get(i), depth + 1, childClusteringMethod, childResultClustering, clusteringMethodStr, numberClusters);
                } else {
                    if (childResultClustering.size() == 1) {
                        ClusteringNode uniqueClusteringNode = new ClusteringNode(childAbstractMatrix, childListMembers, depth + 2, childListMembers, this.root.getListChildNodes().get(i));
                        this.root.getListChildNodes().get(i).addChildNode(uniqueClusteringNode);
                        if (totalLevels < depth + 2);
                        {
                            totalLevels = depth + 2;
                        }
                    }
                }
            }
        }

    }

    public void buildTimeIntervalTree(ClusteringNode node, int depth, Clustering clusteringMethod, ArrayList<ArrayList<Integer>> resultClustering, String clusteringMethodStr, int numberClusters) throws IOException {

        if (node.getAbstractMatrix() == null || node.getAbstractMatrix().getRowCount() == 0) {
            return;
        }

        if (totalLevels < depth);
        {
            totalLevels = depth;
        }
        if (resultClustering.size() > 1) {

            for (int i = 0; i < resultClustering.size(); i++) {
                AbstractMatrix childAbstractMatrix = new DenseMatrix();
                ArrayList<Integer> childListMembers = new ArrayList<Integer>();
                ArrayList<Integer> childListMedoids = new ArrayList<Integer>();
                for (int j = 0; j < resultClustering.get(i).size(); j++) {
                    childAbstractMatrix.addRow(node.getAbstractMatrix().getRow(resultClustering.get(i).get(j)));
                    childListMembers.add(node.getListMembers().get(resultClustering.get(i).get(j)));
                }

                Clustering childClusteringMethod = null;
                if (clusteringMethodStr.equals("Xmeans")) {
                    childClusteringMethod = new Xmeans(childAbstractMatrix.getRowCount());
                } else {
                    if (clusteringMethodStr.equals("Kmeans")) {
                        childClusteringMethod = new Kmeans(numberClusters);
                    } else {
                        if (clusteringMethodStr.equals("Kmedoids")) {
                            childClusteringMethod = new Kmedoids(numberClusters);
                        } else {

                            if (clusteringMethodStr.equals("BKmeans")) {
                                childClusteringMethod = new BKmeans(numberClusters);
                            } else {

                                if (clusteringMethodStr.equals("BKmedoids")) {
                                    childClusteringMethod = new BKmedoids(numberClusters);
                                }
                            }
                        }
                    }
                }

                //new Xmeans(childAbstractMatrix.getRowCount());
                ArrayList<ArrayList<Integer>> childResultClustering = childClusteringMethod.execute(new EuclideanSimilarity(), childAbstractMatrix);

                int[] childListMedoidsCluster = childClusteringMethod.getMedoids(childAbstractMatrix);

                for (int k = 0; k < childListMedoidsCluster.length; k++) {
                    childListMedoids.add(childListMembers.get(childListMedoidsCluster[k]));

                }

                ClusteringNode clusteringNode = new ClusteringNode(childAbstractMatrix, childListMedoids, depth + 1, childListMembers, node);
                node.addChildNode(clusteringNode);

                if (childResultClustering.size() > 1) {
                    buildTimeIntervalTree(node.getListChildNodes().get(i), depth + 1, childClusteringMethod, childResultClustering, clusteringMethodStr, numberClusters);
                } else {
                    if (childResultClustering.size() == 1) {
                        ClusteringNode uniqueClusteringNode = new ClusteringNode(childAbstractMatrix, childListMembers, depth + 2, childListMembers, node.getListChildNodes().get(i));
                        node.getListChildNodes().get(i).addChildNode(uniqueClusteringNode);
                        if (totalLevels < depth + 2);
                        {
                            totalLevels = depth + 2;
                        }
                    }
                }
            }

        }

    }
}
