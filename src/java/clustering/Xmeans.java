/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package clustering;

import java.io.IOException;
import java.util.ArrayList;
import matrix.distancematrix.DistanceMatrix;
import distance.AbstractDissimilarity;
import matrix.pointsmatrix.AbstractMatrix;
import matrix.pointsmatrix.AbstractVector;
import matrix.pointsmatrix.DenseMatrix;
import matrix.pointsmatrix.DenseVector;

import weka.clusterers.XMeans;
import weka.core.Attribute;
import weka.core.Instance;
import weka.core.FastVector;
import weka.core.Instance;
import weka.core.Instances;

/**
 *
 * @author thiago
 */
public class Xmeans extends Clustering {

    public Xmeans(int maxClusters) {
        super(maxClusters);
        this.maxClusters = maxClusters;

        int nSeeds = (int) (maxClusters * 0.4);
        if (nSeeds < 1) {
            nSeeds = 1;
        }
        xmeans = new XMeans();

        xmeans.setMaxNumClusters(maxClusters);
        xmeans.setSeed(nSeeds);

        double factor =0.06;
         if ((maxClusters * factor) <= 1) {
         if (maxClusters <= 1) {
         xmeans.setMinNumClusters(1);

         } else {
         xmeans.setMinNumClusters(2);
         }

         } else {

         xmeans.setMinNumClusters((int) (maxClusters * factor));
         }
        xmeans.setUseKDTree(false);
    }

    public Instances transformAbstractMatrixInstances(AbstractMatrix matrix) {
        Instances instances = null;
        if (matrix != null) {
            ArrayList<Attribute> labels = transformeLabelsAttributes(matrix.getDimensions());

            FastVector l = new FastVector();
            for (Attribute label : labels) {
                l.addElement(label);
            }
            //instances = new Instances("AbstractMatrix", labels, nrclusters);
            instances = new Instances("AbstractMatrix", l, nrclusters);
            Instance inst = null;
            for (int i = 0; i < matrix.getRowCount(); i++) {
                inst = new Instance(1, transformeFloatArrayToDoubleArray(matrix.getRow(i).getValues()));
                instances.add(inst);
            }
        }
        return instances;
    }

    private double[] transformeFloatArrayToDoubleArray(float[] array) {
        double[] values = null;
        if (array != null) {
            values = new double[array.length];
            for (int i = 0; i < array.length; i++) {
                values[i] = array[i];
            }
        }
        return values;
    }

    private ArrayList<Attribute> transformeLabelsAttributes(int size) {
        ArrayList<Attribute> att = null;
        if (size > 0) {
            att = new ArrayList<>(size);
            for (int i = 0; i < size; i++) {
                att.add(new Attribute("Att" + i));
            }
        }
        return att;
    }

    @Override
    public ArrayList<ArrayList<Integer>> execute(AbstractDissimilarity diss, AbstractMatrix matrix) throws IOException {

        this.diss = diss;
        clusters.clear();
        //ArrayList<ArrayList<Integer>> list = null;
        Instances inst = transformAbstractMatrixInstances(matrix);
        try {
            //for(int i = minClusters; i < maxClusters; i++) {
            xmeans.buildClusterer(inst);
            //System.out.println("--Processando x-means: " + i + " - Bin Value: " +xmeans.getBinValue() );
            //}
            Instances centers = xmeans.getClusterCenters();
            //clusters = new ArrayList<>(centers.numInstances());
            for (int i = 0; i < centers.numInstances(); i++) {
                clusters.add(new ArrayList<Integer>());
            }
            for (int i = 0; i < inst.numInstances(); i++) {
                int idClusters = xmeans.clusterInstance(inst.instance(i));
                clusters.get(idClusters).add(i);
            }
            for (int i = 0; i < clusters.size(); i++) {
                if (clusters.get(i).isEmpty()) {
                    clusters.remove(i);
                    i--;
                }
            }
            getCentroids();
        } catch (Exception ex) {
            //Logger.getLogger(Xmeans.class.getName()).log(Level.SEVERE, null, ex);
            xmeans.setMinNumClusters(1);
            this.execute(diss, matrix);
        }

        return clusters;
    }

    public int getClusters() {
        return clusters.size();
    }

    @Override
    public AbstractMatrix getCentroids() {

        centroids = new DenseMatrix();
        Instances centers = xmeans.getClusterCenters();

        for (int i = 0; i < clusters.size(); i++) {
            Instance ins = centers.instance(i);
            float[] values = new float[ins.numValues()];
            for (int j = 0; j < ins.numValues(); j++) {
                values[j] = (float) ins.value(j);
            }
            AbstractVector row = new DenseVector(values);
            centroids.addRow(row);
        }
        return centroids;
    }

    @Override
    public int[] getMedoids(AbstractMatrix matrix) throws IOException {
        int[] m = new int[this.clusters.size()];

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
    @Override
    public ArrayList<ArrayList<Integer>> getListClusters() {
       return clusters;
    }
    @Override
    public ArrayList<ArrayList<Integer>> execute(DistanceMatrix dmat) throws IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    private int maxClusters;
    //private int clustersFinal;
    private XMeans xmeans;
    private  ArrayList<ArrayList<Integer>> clusters = new ArrayList<>();
    private AbstractMatrix centroids;
    protected AbstractDissimilarity diss;



}
