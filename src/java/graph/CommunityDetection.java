/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package graph;

import edu.uci.ics.jung.algorithms.cluster.EdgeBetweennessClusterer;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.UndirectedSparseGraph;
import edu.uci.ics.jung.graph.util.EdgeType;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Set;

/**
 *
 * @author aurea
 */
public class CommunityDetection {

    static int edgeCount_Undirected = 0;
    Set<Set<Vertex>> communities;
    Graph<Vertex, Edge> undirectedSparseGraph;
    String d3FormatCommunities;
    String d3FormatEdges;

    public Set<Set<Vertex>> communityDetectionBetwenessCentrality(String selectedAttributesArray[], double[][] weightMatrix) {

        List<String> listNodes = new ArrayList<>();
        List<Integer> listCommunities = new ArrayList<>();

        for (String selectedAttributesArray1 : selectedAttributesArray) {
            listNodes.add(selectedAttributesArray1);
            listCommunities.add(0);
        }

        //create undirected sparse graph
        undirectedSparseGraph = new UndirectedSparseGraph<>();

        //create node objects
        Hashtable<String, Vertex> graphNodes = new Hashtable<>();

        //create graph nodes
        for (int i = 0; i < selectedAttributesArray.length; i++) {
            Vertex data = new Vertex(selectedAttributesArray[i], i);
            graphNodes.put(selectedAttributesArray[i], data);
        }

        //create edges Format D3
        d3FormatEdges = "[";

        //create connections 
        for (int i = 0; i < weightMatrix.length; i++) {
            for (int j = i; j < weightMatrix[i].length; j++) {
                if (((weightMatrix[i][j] >= 0.9) ) && i != j) {//|| (weightMatrix[i][j] <= -0.7)
                    undirectedSparseGraph.addEdge(new Edge(weightMatrix[i][j], edgeCount_Undirected), graphNodes.get(selectedAttributesArray[i]), graphNodes.get(selectedAttributesArray[j]), EdgeType.UNDIRECTED);
                    d3FormatEdges += "{\"source\":" + i + " , \"target\": " + j + ", \"value\": " + weightMatrix[i][j] + "},\n";
                    d3FormatEdges += "{\"source\":" + j + " , \"target\": " + i + ", \"value\": " + weightMatrix[i][j] + "},\n";
                    edgeCount_Undirected++;
                }
            }
        }
        d3FormatEdges += "]";

        //graph
        //System.out.println("Graph: " + undirectedSparseGraph);
        // graph algorithms
        edu.uci.ics.jung.algorithms.cluster.EdgeBetweennessClusterer<Vertex, Edge> edgeBetwennes = new EdgeBetweennessClusterer<>(1);

        communities = edgeBetwennes.transform(undirectedSparseGraph);
        /*Set<Set<Vertex>> communities = edgeBetwennes.transform(undirectedSparseGraph);
         Iterator<Set<Vertex>> keys = communities.iterator();
         while (keys.hasNext()) {
         System.out.println(keys.next());
         }*/
        int numberCommunity = 1;
        for (Set<Vertex> comm : communities) {
            for (Vertex v : comm) {
                listCommunities.set(listNodes.indexOf(v.getId()), numberCommunity);
            }
            numberCommunity++;
        }

        for (int i = 0; i < listNodes.size(); i++) {
            if (listCommunities.get(i).equals(0)) {
                listCommunities.set(i, numberCommunity);
                numberCommunity++;
            }

        }

        d3FormatCommunities = "[";
        for (int i = 0; i < listNodes.size(); i++) {
            d3FormatCommunities += "{\"name\":\"" + listNodes.get(i) + "\",\"group\":" + listCommunities.get(i) + "},\n";
        }
        d3FormatCommunities += "]";
        return communities;
    }

    public Set<Set<Vertex>> getCommunities() {
        return communities;
    }

    public Graph<Vertex, Edge> getUndirectedSparseGraph() {
        return undirectedSparseGraph;
    }

    public String getD3FormatEdges() {

        /* String d3FormatEdges = "[\n"
         + "                        {\"source\": 1, \"target\": 0, \"value\": 1},\n"
         + "                        {\"source\": 2, \"target\": 0, \"value\": 8},\n"
         + "                        {\"source\": 3, \"target\": 0, \"value\": 10},\n"
         + "                        {\"source\": 3, \"target\": 2, \"value\": 6},\n"
         + "                        {\"source\": 4, \"target\": 0, \"value\": 1},\n"
         + "                        {\"source\": 5, \"target\": 0, \"value\": 1},\n"
         + "                        {\"source\": 6, \"target\": 0, \"value\": 1},\n"
         + "                        {\"source\": 7, \"target\": 0, \"value\": 1},\n"
         + "                        {\"source\": 8, \"target\": 0, \"value\": 2},\n"
         + "                        {\"source\": 9, \"target\": 0, \"value\": 1},\n"
         + "                        {\"source\": 11, \"target\": 10, \"value\": 1},\n"
         + "                        {\"source\": 11, \"target\": 3, \"value\": 3},\n"
         + "                        {\"source\": 11, \"target\": 2, \"value\": 3},\n"
         + "                        {\"source\": 11, \"target\": 0, \"value\": 5},\n"
         + "                        {\"source\": 12, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 13, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 14, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 15, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 17, \"target\": 16, \"value\": 4},\n"
         + "                        {\"source\": 18, \"target\": 16, \"value\": 4},\n"
         + "                        {\"source\": 18, \"target\": 17, \"value\": 4},\n"
         + "                        {\"source\": 19, \"target\": 16, \"value\": 4},\n"
         + "                        {\"source\": 19, \"target\": 17, \"value\": 4},\n"
         + "                        {\"source\": 19, \"target\": 18, \"value\": 4},\n"
         + "                        {\"source\": 20, \"target\": 16, \"value\": 3},\n"
         + "                        {\"source\": 20, \"target\": 17, \"value\": 3},\n"
         + "                        {\"source\": 20, \"target\": 18, \"value\": 3},\n"
         + "                        {\"source\": 20, \"target\": 19, \"value\": 4},\n"
         + "                        {\"source\": 21, \"target\": 16, \"value\": 3},\n"
         + "                        {\"source\": 21, \"target\": 17, \"value\": 3},\n"
         + "                        {\"source\": 21, \"target\": 18, \"value\": 3},\n"
         + "                        {\"source\": 21, \"target\": 19, \"value\": 3},\n"
         + "                        {\"source\": 21, \"target\": 20, \"value\": 5},\n"
         + "                        {\"source\": 22, \"target\": 16, \"value\": 3},\n"
         + "                        {\"source\": 22, \"target\": 17, \"value\": 3},\n"
         + "                        {\"source\": 22, \"target\": 18, \"value\": 3},\n"
         + "                        {\"source\": 22, \"target\": 19, \"value\": 3},\n"
         + "                        {\"source\": 22, \"target\": 20, \"value\": 4},\n"
         + "                        {\"source\": 22, \"target\": 21, \"value\": 4},\n"
         + "                        {\"source\": 23, \"target\": 16, \"value\": 3},\n"
         + "                        {\"source\": 23, \"target\": 17, \"value\": 3},\n"
         + "                        {\"source\": 23, \"target\": 18, \"value\": 3},\n"
         + "                        {\"source\": 23, \"target\": 19, \"value\": 3},\n"
         + "                        {\"source\": 23, \"target\": 20, \"value\": 4},\n"
         + "                        {\"source\": 23, \"target\": 21, \"value\": 4},\n"
         + "                        {\"source\": 23, \"target\": 22, \"value\": 4},\n"
         + "                        {\"source\": 23, \"target\": 12, \"value\": 2},\n"
         + "                        {\"source\": 23, \"target\": 11, \"value\": 9},\n"
         + "                        {\"source\": 24, \"target\": 23, \"value\": 2},\n"
         + "                        {\"source\": 24, \"target\": 11, \"value\": 7},\n"
         + "                        {\"source\": 25, \"target\": 24, \"value\": 13},\n"
         + "                        {\"source\": 25, \"target\": 23, \"value\": 1},\n"
         + "                        {\"source\": 25, \"target\": 11, \"value\": 12},\n"
         + "                        {\"source\": 26, \"target\": 24, \"value\": 4},\n"
         + "                        {\"source\": 26, \"target\": 11, \"value\": 31},\n"
         + "                        {\"source\": 26, \"target\": 16, \"value\": 1},\n"
         + "                        {\"source\": 26, \"target\": 25, \"value\": 1},\n"
         + "                        {\"source\": 27, \"target\": 11, \"value\": 17},\n"
         + "                        {\"source\": 27, \"target\": 23, \"value\": 5},\n"
         + "                        {\"source\": 27, \"target\": 25, \"value\": 5},\n"
         + "                        {\"source\": 27, \"target\": 24, \"value\": 1},\n"
         + "                        {\"source\": 27, \"target\": 26, \"value\": 1},\n"
         + "                        {\"source\": 28, \"target\": 11, \"value\": 8},\n"
         + "                        {\"source\": 28, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 29, \"target\": 23, \"value\": 1},\n"
         + "                        {\"source\": 29, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 29, \"target\": 11, \"value\": 2},\n"
         + "                        {\"source\": 30, \"target\": 23, \"value\": 1},\n"
         + "                        {\"source\": 31, \"target\": 30, \"value\": 2},\n"
         + "                        {\"source\": 31, \"target\": 11, \"value\": 3},\n"
         + "                        {\"source\": 31, \"target\": 23, \"value\": 2},\n"
         + "                        {\"source\": 31, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 32, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 33, \"target\": 11, \"value\": 2},\n"
         + "                        {\"source\": 33, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 34, \"target\": 11, \"value\": 3},\n"
         + "                        {\"source\": 34, \"target\": 29, \"value\": 2},\n"
         + "                        {\"source\": 35, \"target\": 11, \"value\": 3},\n"
         + "                        {\"source\": 35, \"target\": 34, \"value\": 3},\n"
         + "                        {\"source\": 35, \"target\": 29, \"value\": 2},\n"
         + "                        {\"source\": 36, \"target\": 34, \"value\": 2},\n"
         + "                        {\"source\": 36, \"target\": 35, \"value\": 2},\n"
         + "                        {\"source\": 36, \"target\": 11, \"value\": 2},\n"
         + "                        {\"source\": 36, \"target\": 29, \"value\": 1},\n"
         + "                        {\"source\": 37, \"target\": 34, \"value\": 2},\n"
         + "                        {\"source\": 37, \"target\": 35, \"value\": 2},\n"
         + "                        {\"source\": 37, \"target\": 36, \"value\": 2},\n"
         + "                        {\"source\": 37, \"target\": 11, \"value\": 2},\n"
         + "                        {\"source\": 37, \"target\": 29, \"value\": 1},\n"
         + "                        {\"source\": 38, \"target\": 34, \"value\": 2},\n"
         + "                        {\"source\": 38, \"target\": 35, \"value\": 2},\n"
         + "                        {\"source\": 38, \"target\": 36, \"value\": 2},\n"
         + "                        {\"source\": 38, \"target\": 37, \"value\": 2},\n"
         + "                        {\"source\": 38, \"target\": 11, \"value\": 2},\n"
         + "                        {\"source\": 38, \"target\": 29, \"value\": 1},\n"
         + "                        {\"source\": 39, \"target\": 25, \"value\": 1},\n"
         + "                        {\"source\": 40, \"target\": 25, \"value\": 1},\n"
         + "                        {\"source\": 41, \"target\": 24, \"value\": 2},\n"
         + "                        {\"source\": 41, \"target\": 25, \"value\": 3},\n"
         + "                        {\"source\": 42, \"target\": 41, \"value\": 2},\n"
         + "                        {\"source\": 42, \"target\": 25, \"value\": 2},\n"
         + "                        {\"source\": 42, \"target\": 24, \"value\": 1},\n"
         + "                        {\"source\": 43, \"target\": 11, \"value\": 3},\n"
         + "                        {\"source\": 43, \"target\": 26, \"value\": 1},\n"
         + "                        {\"source\": 43, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 44, \"target\": 28, \"value\": 3},\n"
         + "                        {\"source\": 44, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 45, \"target\": 28, \"value\": 2},\n"
         + "                        {\"source\": 47, \"target\": 46, \"value\": 1},\n"
         + "                        {\"source\": 48, \"target\": 47, \"value\": 2},\n"
         + "                        {\"source\": 48, \"target\": 25, \"value\": 1},\n"
         + "                        {\"source\": 48, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 48, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 49, \"target\": 26, \"value\": 3},\n"
         + "                        {\"source\": 49, \"target\": 11, \"value\": 2},\n"
         + "                        {\"source\": 50, \"target\": 49, \"value\": 1},\n"
         + "                        {\"source\": 50, \"target\": 24, \"value\": 1},\n"
         + "                        {\"source\": 51, \"target\": 49, \"value\": 9},\n"
         + "                        {\"source\": 51, \"target\": 26, \"value\": 2},\n"
         + "                        {\"source\": 51, \"target\": 11, \"value\": 2},\n"
         + "                        {\"source\": 52, \"target\": 51, \"value\": 1},\n"
         + "                        {\"source\": 52, \"target\": 39, \"value\": 1},\n"
         + "                        {\"source\": 53, \"target\": 51, \"value\": 1},\n"
         + "                        {\"source\": 54, \"target\": 51, \"value\": 2},\n"
         + "                        {\"source\": 54, \"target\": 49, \"value\": 1},\n"
         + "                        {\"source\": 54, \"target\": 26, \"value\": 1},\n"
         + "                        {\"source\": 55, \"target\": 51, \"value\": 6},\n"
         + "                        {\"source\": 55, \"target\": 49, \"value\": 12},\n"
         + "                        {\"source\": 55, \"target\": 39, \"value\": 1},\n"
         + "                        {\"source\": 55, \"target\": 54, \"value\": 1},\n"
         + "                        {\"source\": 55, \"target\": 26, \"value\": 21},\n"
         + "                        {\"source\": 55, \"target\": 11, \"value\": 19},\n"
         + "                        {\"source\": 55, \"target\": 16, \"value\": 1},\n"
         + "                        {\"source\": 55, \"target\": 25, \"value\": 2},\n"
         + "                        {\"source\": 55, \"target\": 41, \"value\": 5},\n"
         + "                        {\"source\": 55, \"target\": 48, \"value\": 4},\n"
         + "                        {\"source\": 56, \"target\": 49, \"value\": 1},\n"
         + "                        {\"source\": 56, \"target\": 55, \"value\": 1},\n"
         + "                        {\"source\": 57, \"target\": 55, \"value\": 1},\n"
         + "                        {\"source\": 57, \"target\": 41, \"value\": 1},\n"
         + "                        {\"source\": 57, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 58, \"target\": 55, \"value\": 7},\n"
         + "                        {\"source\": 58, \"target\": 48, \"value\": 7},\n"
         + "                        {\"source\": 58, \"target\": 27, \"value\": 6},\n"
         + "                        {\"source\": 58, \"target\": 57, \"value\": 1},\n"
         + "                        {\"source\": 58, \"target\": 11, \"value\": 4},\n"
         + "                        {\"source\": 59, \"target\": 58, \"value\": 15},\n"
         + "                        {\"source\": 59, \"target\": 55, \"value\": 5},\n"
         + "                        {\"source\": 59, \"target\": 48, \"value\": 6},\n"
         + "                        {\"source\": 59, \"target\": 57, \"value\": 2},\n"
         + "                        {\"source\": 60, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 60, \"target\": 58, \"value\": 4},\n"
         + "                        {\"source\": 60, \"target\": 59, \"value\": 2},\n"
         + "                        {\"source\": 61, \"target\": 48, \"value\": 2},\n"
         + "                        {\"source\": 61, \"target\": 58, \"value\": 6},\n"
         + "                        {\"source\": 61, \"target\": 60, \"value\": 2},\n"
         + "                        {\"source\": 61, \"target\": 59, \"value\": 5},\n"
         + "                        {\"source\": 61, \"target\": 57, \"value\": 1},\n"
         + "                        {\"source\": 61, \"target\": 55, \"value\": 1},\n"
         + "                        {\"source\": 62, \"target\": 55, \"value\": 9},\n"
         + "                        {\"source\": 62, \"target\": 58, \"value\": 17},\n"
         + "                        {\"source\": 62, \"target\": 59, \"value\": 13},\n"
         + "                        {\"source\": 62, \"target\": 48, \"value\": 7},\n"
         + "                        {\"source\": 62, \"target\": 57, \"value\": 2},\n"
         + "                        {\"source\": 62, \"target\": 41, \"value\": 1},\n"
         + "                        {\"source\": 62, \"target\": 61, \"value\": 6},\n"
         + "                        {\"source\": 62, \"target\": 60, \"value\": 3},\n"
         + "                        {\"source\": 63, \"target\": 59, \"value\": 5},\n"
         + "                        {\"source\": 63, \"target\": 48, \"value\": 5},\n"
         + "                        {\"source\": 63, \"target\": 62, \"value\": 6},\n"
         + "                        {\"source\": 63, \"target\": 57, \"value\": 2},\n"
         + "                        {\"source\": 63, \"target\": 58, \"value\": 4},\n"
         + "                        {\"source\": 63, \"target\": 61, \"value\": 3},\n"
         + "                        {\"source\": 63, \"target\": 60, \"value\": 2},\n"
         + "                        {\"source\": 63, \"target\": 55, \"value\": 1},\n"
         + "                        {\"source\": 64, \"target\": 55, \"value\": 5},\n"
         + "                        {\"source\": 64, \"target\": 62, \"value\": 12},\n"
         + "                        {\"source\": 64, \"target\": 48, \"value\": 5},\n"
         + "                        {\"source\": 64, \"target\": 63, \"value\": 4},\n"
         + "                        {\"source\": 64, \"target\": 58, \"value\": 10},\n"
         + "                        {\"source\": 64, \"target\": 61, \"value\": 6},\n"
         + "                        {\"source\": 64, \"target\": 60, \"value\": 2},\n"
         + "                        {\"source\": 64, \"target\": 59, \"value\": 9},\n"
         + "                        {\"source\": 64, \"target\": 57, \"value\": 1},\n"
         + "                        {\"source\": 64, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 65, \"target\": 63, \"value\": 5},\n"
         + "                        {\"source\": 65, \"target\": 64, \"value\": 7},\n"
         + "                        {\"source\": 65, \"target\": 48, \"value\": 3},\n"
         + "                        {\"source\": 65, \"target\": 62, \"value\": 5},\n"
         + "                        {\"source\": 65, \"target\": 58, \"value\": 5},\n"
         + "                        {\"source\": 65, \"target\": 61, \"value\": 5},\n"
         + "                        {\"source\": 65, \"target\": 60, \"value\": 2},\n"
         + "                        {\"source\": 65, \"target\": 59, \"value\": 5},\n"
         + "                        {\"source\": 65, \"target\": 57, \"value\": 1},\n"
         + "                        {\"source\": 65, \"target\": 55, \"value\": 2},\n"
         + "                        {\"source\": 66, \"target\": 64, \"value\": 3},\n"
         + "                        {\"source\": 66, \"target\": 58, \"value\": 3},\n"
         + "                        {\"source\": 66, \"target\": 59, \"value\": 1},\n"
         + "                        {\"source\": 66, \"target\": 62, \"value\": 2},\n"
         + "                        {\"source\": 66, \"target\": 65, \"value\": 2},\n"
         + "                        {\"source\": 66, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 66, \"target\": 63, \"value\": 1},\n"
         + "                        {\"source\": 66, \"target\": 61, \"value\": 1},\n"
         + "                        {\"source\": 66, \"target\": 60, \"value\": 1},\n"
         + "                        {\"source\": 67, \"target\": 57, \"value\": 3},\n"
         + "                        {\"source\": 68, \"target\": 25, \"value\": 5},\n"
         + "                        {\"source\": 68, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 68, \"target\": 24, \"value\": 1},\n"
         + "                        {\"source\": 68, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 68, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 68, \"target\": 41, \"value\": 1},\n"
         + "                        {\"source\": 69, \"target\": 25, \"value\": 6},\n"
         + "                        {\"source\": 69, \"target\": 68, \"value\": 6},\n"
         + "                        {\"source\": 69, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 69, \"target\": 24, \"value\": 1},\n"
         + "                        {\"source\": 69, \"target\": 27, \"value\": 2},\n"
         + "                        {\"source\": 69, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 69, \"target\": 41, \"value\": 1},\n"
         + "                        {\"source\": 70, \"target\": 25, \"value\": 4},\n"
         + "                        {\"source\": 70, \"target\": 69, \"value\": 4},\n"
         + "                        {\"source\": 70, \"target\": 68, \"value\": 4},\n"
         + "                        {\"source\": 70, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 70, \"target\": 24, \"value\": 1},\n"
         + "                        {\"source\": 70, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 70, \"target\": 41, \"value\": 1},\n"
         + "                        {\"source\": 70, \"target\": 58, \"value\": 1},\n"
         + "                        {\"source\": 71, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 71, \"target\": 69, \"value\": 2},\n"
         + "                        {\"source\": 71, \"target\": 68, \"value\": 2},\n"
         + "                        {\"source\": 71, \"target\": 70, \"value\": 2},\n"
         + "                        {\"source\": 71, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 71, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 71, \"target\": 41, \"value\": 1},\n"
         + "                        {\"source\": 71, \"target\": 25, \"value\": 1},\n"
         + "                        {\"source\": 72, \"target\": 26, \"value\": 2},\n"
         + "                        {\"source\": 72, \"target\": 27, \"value\": 1},\n"
         + "                        {\"source\": 72, \"target\": 11, \"value\": 1},\n"
         + "                        {\"source\": 73, \"target\": 48, \"value\": 2},\n"
         + "                        {\"source\": 74, \"target\": 48, \"value\": 2},\n"
         + "                        {\"source\": 74, \"target\": 73, \"value\": 3},\n"
         + "                        {\"source\": 75, \"target\": 69, \"value\": 3},\n"
         + "                        {\"source\": 75, \"target\": 68, \"value\": 3},\n"
         + "                        {\"source\": 75, \"target\": 25, \"value\": 3},\n"
         + "                        {\"source\": 75, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 75, \"target\": 41, \"value\": 1},\n"
         + "                        {\"source\": 75, \"target\": 70, \"value\": 1},\n"
         + "                        {\"source\": 75, \"target\": 71, \"value\": 1},\n"
         + "                        {\"source\": 76, \"target\": 64, \"value\": 1},\n"
         + "                        {\"source\": 76, \"target\": 65, \"value\": 1},\n"
         + "                        {\"source\": 76, \"target\": 66, \"value\": 1},\n"
         + "                        {\"source\": 76, \"target\": 63, \"value\": 1},\n"
         + "                        {\"source\": 76, \"target\": 62, \"value\": 1},\n"
         + "                        {\"source\": 76, \"target\": 48, \"value\": 1},\n"
         + "                        {\"source\": 76, \"target\": 58, \"value\": 1}\n"
         + "                    ];";*/
        return d3FormatEdges;
    }

    public String getD3FormatCommunites() {

        /*  String d3FormatCommunities = "[{\"name\":\"Myriel\",\"group\":1},\n"
         + "    {\"name\":\"Napoleon\",\"group\":1},\n"
         + "    {\"name\":\"Mlle.Baptistine\",\"group\":1},\n"
         + "    {\"name\":\"Mme.Magloire\",\"group\":1},\n"
         + "    {\"name\":\"CountessdeLo\",\"group\":1},\n"
         + "    {\"name\":\"Geborand\",\"group\":1},\n"
         + "    {\"name\":\"Champtercier\",\"group\":1},\n"
         + "    {\"name\":\"Cravatte\",\"group\":1},\n"
         + "    {\"name\":\"Count\",\"group\":1},\n"
         + "    {\"name\":\"OldMan\",\"group\":1},\n"
         + "    {\"name\":\"Labarre\",\"group\":2},\n"
         + "    {\"name\":\"Valjean\",\"group\":2},\n"
         + "    {\"name\":\"Marguerite\",\"group\":3},\n"
         + "    {\"name\":\"Mme.deR\",\"group\":2},\n"
         + "    {\"name\":\"Isabeau\",\"group\":2},\n"
         + "    {\"name\":\"Gervais\",\"group\":2},\n"
         + "    {\"name\":\"Tholomyes\",\"group\":3},\n"
         + "    {\"name\":\"Listolier\",\"group\":3},\n"
         + "    {\"name\":\"Fameuil\",\"group\":3},\n"
         + "    {\"name\":\"Blacheville\",\"group\":3},\n"
         + "    {\"name\":\"Favourite\",\"group\":3},\n"
         + "    {\"name\":\"Dahlia\",\"group\":3},\n"
         + "    {\"name\":\"Zephine\",\"group\":3},\n"
         + "    {\"name\":\"Fantine\",\"group\":3},\n"
         + "    {\"name\":\"Mme.Thenardier\",\"group\":4},\n"
         + "    {\"name\":\"Thenardier\",\"group\":4},\n"
         + "    {\"name\":\"Cosette\",\"group\":5},\n"
         + "    {\"name\":\"Javert\",\"group\":4},\n"
         + "    {\"name\":\"Fauchelevent\",\"group\":0},\n"
         + "    {\"name\":\"Bamatabois\",\"group\":2},\n"
         + "    {\"name\":\"Perpetue\",\"group\":3},\n"
         + "    {\"name\":\"Simplice\",\"group\":2},\n"
         + "    {\"name\":\"Scaufflaire\",\"group\":2},\n"
         + "    {\"name\":\"Woman1\",\"group\":2},\n"
         + "    {\"name\":\"Judge\",\"group\":2},\n"
         + "    {\"name\":\"Champmathieu\",\"group\":2},\n"
         + "    {\"name\":\"Brevet\",\"group\":2},\n"
         + "    {\"name\":\"Chenildieu\",\"group\":2},\n"
         + "    {\"name\":\"Cochepaille\",\"group\":2},\n"
         + "    {\"name\":\"Pontmercy\",\"group\":4},\n"
         + "    {\"name\":\"Boulatruelle\",\"group\":6},\n"
         + "    {\"name\":\"Eponine\",\"group\":4},\n"
         + "    {\"name\":\"Anzelma\",\"group\":4},\n"
         + "    {\"name\":\"Woman2\",\"group\":5},\n"
         + "    {\"name\":\"MotherInnocent\",\"group\":0},\n"
         + "    {\"name\":\"Gribier\",\"group\":0},\n"
         + "    {\"name\":\"Jondrette\",\"group\":7},\n"
         + "    {\"name\":\"Mme.Burgon\",\"group\":7},\n"
         + "    {\"name\":\"Gavroche\",\"group\":8},\n"
         + "    {\"name\":\"Gillenormand\",\"group\":5},\n"
         + "    {\"name\":\"Magnon\",\"group\":5},\n"
         + "    {\"name\":\"Mlle.Gillenormand\",\"group\":5},\n"
         + "    {\"name\":\"Mme.Pontmercy\",\"group\":5},\n"
         + "    {\"name\":\"Mlle.Vaubois\",\"group\":5},\n"
         + "    {\"name\":\"Lt.Gillenormand\",\"group\":5},\n"
         + "    {\"name\":\"Marius\",\"group\":8},\n"
         + "    {\"name\":\"BaronessT\",\"group\":5},\n"
         + "    {\"name\":\"Mabeuf\",\"group\":8},\n"
         + "    {\"name\":\"Enjolras\",\"group\":8},\n"
         + "    {\"name\":\"Combeferre\",\"group\":8},\n"
         + "    {\"name\":\"Prouvaire\",\"group\":8},\n"
         + "    {\"name\":\"Feuilly\",\"group\":8},\n"
         + "    {\"name\":\"Courfeyrac\",\"group\":8},\n"
         + "    {\"name\":\"Bahorel\",\"group\":8},\n"
         + "    {\"name\":\"Bossuet\",\"group\":8},\n"
         + "    {\"name\":\"Joly\",\"group\":8},\n"
         + "    {\"name\":\"Grantaire\",\"group\":8},\n"
         + "    {\"name\":\"MotherPlutarch\",\"group\":9},\n"
         + "    {\"name\":\"Gueulemer\",\"group\":4},\n"
         + "    {\"name\":\"Babet\",\"group\":4},\n"
         + "    {\"name\":\"Claquesous\",\"group\":4},\n"
         + "    {\"name\":\"Montparnasse\",\"group\":4},\n"
         + "    {\"name\":\"Toussaint\",\"group\":5},\n"
         + "    {\"name\":\"Child1\",\"group\":10},\n"
         + "    {\"name\":\"Child2\",\"group\":10},\n"
         + "    {\"name\":\"Brujon\",\"group\":4},\n"
         + "    {\"name\":\"Mme.Hucheloup\",\"group\":8}\n"
         + " ]";*/
        return d3FormatCommunities;
    }
}
