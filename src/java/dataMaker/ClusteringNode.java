/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dataMaker;

import java.util.ArrayList;
import matrix.pointsmatrix.AbstractMatrix;

/**
 *
 * @author aurea
 */
public class ClusteringNode {

    AbstractMatrix abstractMatrix;

    ArrayList<Integer> listMedoids = new ArrayList<Integer>();
    ArrayList<Integer> listMembers = new ArrayList<Integer>();
    ArrayList<ClusteringNode> listChildNodes = new ArrayList<ClusteringNode>();
    int depth = 0;
    ClusteringNode parent;

    public ClusteringNode() {
    }

    public ClusteringNode(AbstractMatrix abstractMatrix, ArrayList<Integer> listMedoids, int depth, ArrayList<Integer> listMembers, ClusteringNode parent) {
        this.abstractMatrix = abstractMatrix;
        this.listMedoids = listMedoids;
        this.listChildNodes = new ArrayList<ClusteringNode>();
        this.depth = depth;
        this.parent = parent;
        this.listMembers=listMembers;
    }

    public AbstractMatrix getAbstractMatrix() {
        return abstractMatrix;
    }

    public void setAbstractMatrix(AbstractMatrix abstractMatrix) {
        this.abstractMatrix = abstractMatrix;
    }

    public ArrayList<Integer> getListMedoids() {
        return listMedoids;
    }

    public void setListMedoids(ArrayList<Integer> listMedoids) {
        this.listMedoids = listMedoids;
    }

    public ArrayList<Integer> getListMembers() {
        return listMembers;
    }

    public void setListMembers(ArrayList<Integer> listMembers) {
        this.listMembers = listMembers;
    }

    public ArrayList<ClusteringNode> getListChildNodes() {
        return listChildNodes;
    }

    public void setListChildNodes(ArrayList<ClusteringNode> listChildNodes) {
        this.listChildNodes = listChildNodes;
    }

    public int getDepth() {
        return depth;
    }

    public void setDepth(int depth) {
        this.depth = depth;
    }

    public void addChildNode(ClusteringNode childNode) {

        this.listChildNodes.add(childNode);

    }

    public ClusteringNode getParent() {
        return parent;
    }

    public void setParent(ClusteringNode parent) {
        this.parent = parent;
    }

     public void printListMembers() {
        System.out.print("Members : [");
        for(int i=0;i<listMembers.size();i++){
            System.out.print(listMembers.get(i)+",");
        }
        System.out.println("]");
    }

       public void printListMedoids() {
        System.out.print("Medoids : [");
        for(int i=0;i<listMedoids.size();i++){
            System.out.print(listMedoids.get(i)+",");
        }
        System.out.println("]");
    }

    
    
}
