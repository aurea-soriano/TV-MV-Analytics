/* ***** BEGIN LICENSE BLOCK *****
 *
 * Copyright (c) 2005-2007 Universidade de Sao Paulo, Sao Carlos/SP, Brazil.
 * All Rights Reserved.
 *
 * This file is part of Projection Explorer (PEx).
 *
 * How to cite this work:
 *  
 @inproceedings{paulovich2007pex,
 author = {Fernando V. Paulovich and Maria Cristina F. Oliveira and Rosane 
 Minghim},
 title = {The Projection Explorer: A Flexible Tool for Projection-based 
 Multidimensional Visualization},
 booktitle = {SIBGRAPI '07: Proceedings of the XX Brazilian Symposium on 
 Computer Graphics and Image Processing (SIBGRAPI 2007)},
 year = {2007},
 isbn = {0-7695-2996-8},
 pages = {27--34},
 doi = {http://dx.doi.org/10.1109/SIBGRAPI.2007.39},
 publisher = {IEEE Computer Society},
 address = {Washington, DC, USA},
 }
 *  
 * PEx is free software: you can redistribute it and/or modify it under 
 * the terms of the GNU General Public License as published by the Free 
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * PEx is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
 * for more details.
 *
 * This code was developed by members of Computer Graphics and Image
 * Processing Group (http://www.lcad.icmc.usp.br) at Instituto de Ciencias
 * Matematicas e de Computacao - ICMC - (http://www.icmc.usp.br) of 
 * Universidade de Sao Paulo, Sao Carlos/SP, Brazil. The initial developer 
 * of the original code is Fernando Vieira Paulovich <fpaulovich@gmail.com>.
 *
 * Contributor(s): Rosane Minghim <rminghim@icmc.usp.br>
 *
 * You should have received a copy of the GNU General Public License along 
 * with PEx. If not, see <http://www.gnu.org/licenses/>.
 *
 * ***** END LICENSE BLOCK ***** */
package clustering;

import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import matrix.distancematrix.DistanceMatrix;
import distance.AbstractDissimilarity;
import distance.EuclideanSimilarity;
import distance.ManhattanSimilarity;
import matrix.pointsmatrix.AbstractMatrix;
import matrix.pointsmatrix.AbstractVector;
import matrix.pointsmatrix.DenseMatrix;
import matrix.pointsmatrix.MatrixFactory;
import matrix.pointsmatrix.MatrixUtils;

/**
 *
 * @author Fernando Vieira Paulovich
 */
public class SilhouetteKmeans extends Clustering {

    public SilhouetteKmeans(int maxClusters) {
        super(maxClusters);
        this.maxClusters = maxClusters;
    }

    @Override
    public ArrayList<ArrayList<Integer>> execute(AbstractDissimilarity diss,
            AbstractMatrix matrix) throws IOException {

        Float cs_previous = Float.MIN_VALUE;

        for (int number = 2; number <= this.maxClusters && number < matrix.getRowCount(); number++) {

            try {
                System.out.println(number);
                Kmeans kmeans = new Kmeans(number);
                AbstractMatrix iterativeMatrix = (AbstractMatrix) matrix.clone();
                ArrayList<ArrayList<Integer>> tmpClustering = kmeans.execute(diss, iterativeMatrix);
                for (int countCluster = 0; countCluster < tmpClustering.size(); countCluster++) {
                    for (int itemCluster = 0; itemCluster < tmpClustering.get(countCluster).size(); itemCluster++) {
                        int indexTmpInterval = tmpClustering.get(countCluster).get(itemCluster);
                        iterativeMatrix.getRow(indexTmpInterval).setKlass(countCluster + 1);
                    }
                }

                SilhouetteCoefficient silhouetteCoefficient = new SilhouetteCoefficient();
                float[] silhouetteCoefficients = silhouetteCoefficient.execute(iterativeMatrix, diss);
                float averageSilhouetteCoefficient = silhouetteCoefficient.average(silhouetteCoefficients);
                System.out.println(averageSilhouetteCoefficient);
                System.out.println(averageSilhouetteCoefficient);
                if (cs_previous < averageSilhouetteCoefficient) {
                    System.out.println("entro");
                    cs_previous = averageSilhouetteCoefficient;
                    this.clusters = kmeans.getListClusters();
                    this.centroids = kmeans.getCentroids();
                    this.diss = diss;

                }
                iterativeMatrix = null;
                kmeans = null;
                silhouetteCoefficient = null;
            } catch (CloneNotSupportedException ex) {
                Logger.getLogger(SilhouetteKmeans.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
        return this.clusters;
    }

    @Override
    public ArrayList<ArrayList<Integer>> execute(DistanceMatrix dmat) throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public AbstractMatrix getCentroids() {
        return centroids;
    }

    @Override
    public int[] getMedoids(AbstractMatrix matrix) throws IOException {
        int[] m = new int[this.centroids.getRowCount()];

        for (int i = 0; i < m.length; i++) {
            int point = -1;
            float distance = Float.MAX_VALUE;

            for (int j = 0; j < clusters.get(i).size(); j++) {
                float distance2 = this.diss.calculate(centroids.getRow(i), matrix.getRow(clusters.get(i).get(j)));

                if (distance > distance2) {
                    point = this.clusters.get(i).get(j);
                    distance = distance2;
                }
            }

            m[i] = point;
        }

        return m;
    }

    public void setNumberIterations(int nriterations) {
        this.nriterations = nriterations;
    }

    private void updateCentroids(AbstractMatrix matrix) throws IOException {
        //clean the centroids
        centroids = MatrixFactory.getInstance(matrix.getClass());

        //for each cluster
        for (int cluster = 0; cluster < nrclusters; cluster++) {
            AbstractMatrix vectors = MatrixFactory.getInstance(matrix.getClass());

            //for each point inside a cluster
            for (int el = 0; el < clusters.get(cluster).size(); el++) {
                vectors.addRow(matrix.getRow(clusters.get(cluster).get(el)));
            }

            AbstractVector centroid = MatrixUtils.mean(vectors);
            centroids.addRow(centroid);
        }
    }

    @Override
    public ArrayList<ArrayList<Integer>> getListClusters() {
        return clusters;
    }

    private int maxClusters;
    protected ArrayList<ArrayList<Integer>> clusters = new ArrayList<>();
    private AbstractMatrix centroids;
    protected AbstractDissimilarity diss;
    private int nriterations = 1000;//control the number of iterations
}
